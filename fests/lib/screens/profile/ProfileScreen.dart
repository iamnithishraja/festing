import 'dart:async';
import 'package:fests/globals/constants.dart';
import 'package:fests/main.dart';
import 'package:fests/models/post.dart';
import 'package:fests/providers/postProvider.dart';
import 'package:fests/providers/userProvider.dart';
import 'package:fests/screens/posts/CreateNewPost.dart';
import 'package:fests/screens/profile/othersProfieScreen.dart';
import 'package:fests/screens/profile/updateProfile.dart';
import 'package:fests/utils/debouncer.dart';
import 'package:fests/widgets/listItems/postItems/post_item.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _debouncer = Debouncer(milliseconds: 500);
  bool showFullBio = false;
  bool firstRun = true;
  Future<List<Post>> getUserPosts(int page) async {
    final response = await http.get(
        "$baseUrl/post/user/posts?page=$page", "application/json");
    if (response["success"]) {
      List<Post> userPosts = List<Map<String, dynamic>>.from(response["posts"])
          .map((post) => Post(
                isLiked: post["isLiked"],
                imageURL: post["image"],
                capion: post["caption"],
                id: post["_id"],
                numLikes: post["numLikes"],
                numComments: post["numComments"],
              ))
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
      getUserPosts(pageKey);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _debouncer.dispose();
    _pagingController.dispose();
  }

  final ThemeData themeData =
      ThemeData(useMaterial3: true, brightness: Brightness.dark);
  @override
  Widget build(BuildContext context) {
    if (firstRun) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "Long Press Profile Picture To Edit Profile",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          timeInSecForIosWeb: 4,
          textColor: Colors.white,
          fontSize: 16.0);
      firstRun = false;
    }
    final user = ref.watch(userProvider);
    final dp = user!.avatar == null
        ? AssetImage("assets/images/profile.png")
        : NetworkImage(user.avatar!);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: SearchAnchor(
                      isFullScreen: false,
                      viewConstraints: const BoxConstraints(
                        minHeight: 200,
                        maxHeight: 400,
                      ),
                      headerTextStyle: TextStyle(color: Colors.white),
                      viewBackgroundColor:
                          Theme.of(context).colorScheme.primary,
                      viewTrailing: [],
                      builder:
                          (BuildContext context, SearchController controller) {
                        return SearchBar(
                          padding: const MaterialStatePropertyAll<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 16.0)),
                          hintText: "Search User",
                          elevation: MaterialStatePropertyAll(10),
                          hintStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(color: Colors.white38)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).colorScheme.background),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(color: Colors.white)),
                          onTap: () {
                            controller.openView();
                          },
                          onChanged: (value) {
                            controller.openView();
                          },
                          leading: const Icon(Icons.search),
                        );
                      },
                      suggestionsBuilder: (BuildContext context,
                          SearchController controller) async {
                        if (controller.text.trim() == "") {
                          await ref
                              .watch(allUsersProvider.notifier)
                              .getAllUsers();
                        } else {
                          await ref
                              .read(allUsersProvider.notifier)
                              .getAllUsers(keyword: controller.text);
                        }
                        final users = ref.watch(allUsersProvider);
                        return users.map((usr) {
                          final dp = usr.avatar == null
                              ? AssetImage("assets/images/profile.png")
                              : NetworkImage(usr.avatar!);
                          return GestureDetector(
                            onTap: () {
                              controller.closeView(controller.text);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    OthersProfileScreen(userid: usr.id),
                              ));
                            },
                            child: Card(
                              shadowColor:
                                  Theme.of(context).colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: dp as ImageProvider,
                                  radius: 30,
                                ),
                                minVerticalPadding: 10,
                                tileColor:
                                    Theme.of(context).colorScheme.background,
                                title: Heading(
                                  str: usr.name,
                                  fontSize: 18,
                                ),
                                subtitle: SubHeading(
                                  str: usr.rollno,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        ref.read(userProvider.notifier).logout();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MyApp(),
                        ));
                      },
                      icon: Icon(
                        Icons.logout,
                        color: Colors.red,
                      ))
                ],
              ),
              GestureDetector(
                  onLongPress: () =>
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UpdateProfile(),
                      )),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    shadowColor: Theme.of(context).colorScheme.secondary,
                    color: Theme.of(context).colorScheme.background,
                    child: Column(children: [
                      Row(
                        children: [
                          Padding(
                              padding:
                                  EdgeInsets.only(top: 5, left: 5, right: 5),
                              child: CircleAvatar(
                                backgroundImage: dp as ImageProvider,
                                radius: 70,
                              )),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Heading(
                                  str: user.name.replaceFirst(" ", "\n"),
                                  alignment: TextAlign.center),
                              SubHeading(str: user.rollno),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      launchUrl(Uri.parse(
                                          user.socialLinks!["github"]!));
                                    },
                                    icon: Icon(FontAwesomeIcons.github),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      launchUrl(Uri.parse(
                                          user.socialLinks!["linkdlin"]!));
                                    },
                                    icon: Icon(FontAwesomeIcons.linkedin),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      launchUrl(Uri.parse(user
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
                      if (user.bio != null)
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
                                    ? user.bio!
                                    : (user.bio!.length > 200
                                        ? user.bio!.substring(0, 200) + "..."
                                        : user.bio!),
                                align: TextAlign.center,
                              )),
                        ),
                    ]),
                  )),
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
                        itemBuilder: (context, item, index) => GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  insetPadding: EdgeInsets.all(10),
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: PostItem(
                                      username: user.name,
                                      rollno: user.rollno,
                                      id: item.id,
                                      isLiked: item.isLiked,
                                      postImage: item.imageURL,
                                      caption: item.capion,
                                      numLikes: item.numLikes,
                                      numComments: item.numComments,
                                      profileImage: user.avatar),
                                ),
                              );
                            },
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.white)),
                                    title: Heading(
                                      str: "Delete Post?",
                                      color: Colors.red,
                                    ),
                                    shadowColor:
                                        Theme.of(context).colorScheme.secondary,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    content: SubHeading(
                                        str:
                                            "are you sure you want to delete this post."),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: SubHeading(
                                            str: "Cancel",
                                            color: Colors.green,
                                          )),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          ref
                                              .read(postsProvider.notifier)
                                              .deletePost(item.id);
                                        },
                                        child: SubHeading(
                                          str: "Delete",
                                          color: Colors.red,
                                        ),
                                      )
                                    ]),
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
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreateNewPost(),
          ));
        },
        child: Icon(FontAwesomeIcons.fileArrowUp),
      ),
    );
  }
}
