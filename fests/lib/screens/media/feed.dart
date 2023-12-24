import 'dart:async';
import 'package:fests/globals/constants.dart';
import 'package:fests/models/post.dart';
import 'package:fests/providers/userProvider.dart';
import 'package:fests/widgets/listItems/postItems/post_item_media.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Feed extends ConsumerStatefulWidget {
  const Feed({super.key});

  @override
  ConsumerState<Feed> createState() => _FeedState();
}

class _FeedState extends ConsumerState<Feed> {
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 1);

  Future<List<Post>> getPosts(int page) async {
    final response =
        await http.get("$baseUrl/post/all?page=$page", "application/json");
    if (response["success"]) {

      List<Post> userPosts = List<Map<String, dynamic>>.from(response["posts"])
          .map(
            (post) => Post(
                imageURL: post["image"],
                capion: post["caption"],
                id: post["_id"],
                numLikes: post["numLikes"],
                numComments: post["numComments"],
                creatorId: post["owner"],
                dp: post["dp"],
                name: post["name"],
                rollno: post["rollno"],
                isLiked: post["isLiked"]),
          )
          .toList();
      final isLastPage = userPosts.length < 10;
      if (isLastPage) {
        _pagingController.appendLastPage(userPosts);
      } else {
        final nextPageKey = page + 1;
        _pagingController.appendPage(userPosts, nextPageKey);
      }
      return userPosts;
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      getPosts(pageKey);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 8,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            snap: true,
            bottom: PreferredSize(
                preferredSize: Size(double.infinity, 1), child: Divider()),
            floating: true,
            elevation: 10,
            title: Heading(str: "Feed"),
          )
        ],
        body: RefreshIndicator(
          color: Theme.of(context).colorScheme.secondary,
          onRefresh: () => Future.sync(() => _pagingController.refresh()),
          child: PagedListView<int, Post>(
            padding: EdgeInsets.all(0),
            pagingController: _pagingController,
            physics: ClampingScrollPhysics(),
            builderDelegate: PagedChildBuilderDelegate<Post>(
                newPageProgressIndicatorBuilder: (context) =>
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                noItemsFoundIndicatorBuilder: (context) => Center(
                      child: Heading(str: "No Posts Found"),
                    ),
                itemBuilder: (context, item, index) {
                  return Container(
                    constraints: BoxConstraints(minHeight: 380, maxHeight: 900),
                    child: PostItemFeed(item),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
