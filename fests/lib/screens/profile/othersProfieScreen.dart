import 'dart:async';
import 'package:fests/globals/constants.dart';
import 'package:fests/models/post.dart';
import 'package:fests/providers/userProvider.dart';
import 'package:fests/widgets/listItems/postItems/post_item.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

class OthersProfileScreen extends ConsumerStatefulWidget {
  OthersProfileScreen({required this.userid, super.key});
  String userid;

  @override
  ConsumerState<OthersProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<OthersProfileScreen> {
  bool showFullBio = false;
  bool firstRun = true;
  Future<List<Post>> getUserPosts(int page, String id) async {
    final response = await http.get(
        "$baseUrl/post/user/posts?page=$page&id=$id", "application/json");
    if (response["success"]) {
      List<Post> userPosts = List<Map<String, dynamic>>.from(response["posts"])
          .map(
            (post) => Post(
              imageURL: post["image"],
              capion: post["caption"],
              id: post["_id"],
              numLikes: post["numLikes"],
              numComments: post["numComments"],
              isLiked: post["isLiked"],
            ),
          )
          .toList();
      final isLastPage = userPosts.length < 4;
      if (isLastPage) {
        _pagingController.appendLastPage(userPosts);
      } else {
        _pagingController.appendPage(userPosts, page + 1);
      }
      return userPosts;
    }
    return [];
  }

  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      getUserPosts(pageKey, widget.userid);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  final ThemeData themeData =
      ThemeData(useMaterial3: true, brightness: Brightness.dark);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref.read(allUsersProvider.notifier).getUserDetails(widget.userid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          );
        }

        final dp = snapshot.data!.avatar == null
            ? AssetImage("assets/images/profile.png")
            : NetworkImage(snapshot.data!.avatar!);
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title: Heading(
              str: "${snapshot.data!.name}'s Profile",
              fontSize: 22,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  shadowColor: Theme.of(context).colorScheme.secondary,
                  color: Theme.of(context).colorScheme.background,
                  child: Column(children: [
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                            child: CircleAvatar(
                              backgroundImage: dp as ImageProvider,
                              radius: 70,
                            )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Heading(
                                str:
                                    snapshot.data!.name.replaceFirst(" ", "\n"),
                                alignment: TextAlign.center),
                            SubHeading(str: snapshot.data!.rollno),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    launchUrl(Uri.parse(snapshot
                                        .data!.socialLinks!["github"]!));
                                  },
                                  icon: Icon(FontAwesomeIcons.github),
                                ),
                                IconButton(
                                  onPressed: () {
                                    launchUrl(Uri.parse(snapshot
                                        .data!.socialLinks!["linkdlin"]!));
                                  },
                                  icon: Icon(FontAwesomeIcons.linkedin),
                                ),
                                IconButton(
                                  onPressed: () {
                                    launchUrl(Uri.parse(snapshot.data!
                                        .socialLinks!["codingPlatform"]!));
                                  },
                                  icon: Icon(FontAwesomeIcons.code),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    if (snapshot.data!.bio != null)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showFullBio = !showFullBio;
                              });
                            },
                            child: SubHeading(
                              str: showFullBio
                                  ? snapshot.data!.bio!
                                  : (snapshot.data!.bio!.length > 200
                                      ? snapshot.data!.bio!.substring(0, 200) +
                                          "..."
                                      : snapshot.data!.bio!),
                              align: TextAlign.center,
                            )),
                      ),
                  ]),
                ),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    shadowColor: Theme.of(context).colorScheme.secondary,
                    color: Theme.of(context).colorScheme.background,
                    child: RefreshIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                      onRefresh: () =>
                          Future.sync(() => _pagingController.refresh()),
                      child: PagedGridView<int, Post>(
                        padding: EdgeInsets.all(0),
                        pagingController: _pagingController,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        builderDelegate: PagedChildBuilderDelegate<Post>(
                          noItemsFoundIndicatorBuilder: (context) => Center(
                            child: Heading(str: "No Posts Found"),
                          ),
                          itemBuilder: (context, item, index) =>
                              GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        insetPadding: EdgeInsets.all(10),
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        child: PostItem(
                                            username: snapshot.data!.name,
                                            rollno: snapshot.data!.rollno,
                                            postImage: item.imageURL,
                                            caption: item.capion,
                                            id: item.id,
                                            isLiked: item.isLiked,
                                            numLikes: item.numLikes,
                                            numComments: item.numComments,
                                            profileImage:
                                                snapshot.data!.avatar),
                                      ),
                                    );
                                  },
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        insetPadding: EdgeInsets.all(8),
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        child: PostItem(
                                            username: snapshot.data!.name,
                                            rollno: snapshot.data!.rollno,
                                            postImage: item.imageURL,
                                            caption: item.capion,
                                            id: item.id,
                                            isLiked: item.isLiked,
                                            numLikes: item.numLikes,
                                            numComments: item.numComments,
                                            profileImage:
                                                snapshot.data!.avatar),
                                      ),
                                    );
                                  },
                                  child: Card(
                                      child: Image.network(
                                    item.imageURL,
                                    fit: BoxFit.cover,
                                  ))),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
