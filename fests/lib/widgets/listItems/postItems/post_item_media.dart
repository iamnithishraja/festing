import 'dart:async';
import 'package:fests/models/post.dart';
import 'package:fests/providers/postProvider.dart';
import 'package:fests/screens/profile/othersProfieScreen.dart';
import 'package:fests/widgets/listItems/comments.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_size_getter/image_size_getter.dart';

class PostItemFeed extends ConsumerStatefulWidget {
  PostItemFeed(this.post);
  Post post;
  @override
  _PostItemFeedState createState() => _PostItemFeedState();
}

class _PostItemFeedState extends ConsumerState<PostItemFeed>
    with SingleTickerProviderStateMixin {
  bool showFullCaption = false;
  late bool isLiked;
  bool isHeartAnimating = false;
  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 500), vsync: this, value: 1.0);
  late Animation<double> scale;
  @override
  void initState() {
    super.initState();
    isLiked = widget.post.isLiked;
    scale = Tween<double>(begin: 0, end: 2).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final dp = widget.post.dp == null
        ? AssetImage("assets/images/profile.png")
        : NetworkImage(widget.post.dp!);

    Image image = Image.network(
      widget.post.imageURL,
      fit: BoxFit.fill,
    );

    Future<Size> _calculateImageDimension() {
      Completer<Size> completer = Completer();
      image.image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo image, bool synchronousCall) {
            var myImage = image.image;
            Size size = Size(myImage.width.toInt(), myImage.height.toInt());
            completer.complete(size);
          },
        ),
      );
      return completer.future;
    }

    void likeHandler() {
      setState(() {
        isLiked = !isLiked;
        if (isLiked) {
          isHeartAnimating = true;
          widget.post.numLikes++;
          _controller.forward().then((value) {
            _controller.reverse().then((value) {});
          });
        } else {
          widget.post.numLikes--;
        }
      });
      ref.read(postsProvider.notifier).likeunlikePost(widget.post.id);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          height: 1,
          thickness: 2,
        ),
        Card(
          margin: EdgeInsets.all(0),
          shadowColor: Theme.of(context).colorScheme.secondary,
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      OthersProfileScreen(userid: widget.post.creatorId!),
                )),
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  minVerticalPadding: 0,
                  leading: CircleAvatar(
                    backgroundImage: dp as ImageProvider,
                    radius: 30,
                  ),
                  tileColor: Theme.of(context).colorScheme.background,
                  title: Transform.translate(
                    offset: Offset(-8, 0),
                    child: Heading(
                      str: widget.post.name!,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Transform.translate(
                    offset: Offset(-8, 0),
                    child: SubHeading(
                      str: widget.post.rollno!,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              // Use ClipRRect to give a specific height to the Image
              FutureBuilder(
                future: _calculateImageDimension(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return GestureDetector(
                      onDoubleTap: likeHandler,
                      child: ClipRect(
                        clipBehavior: Clip.none,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: snapshot.data.height > snapshot.data.width
                                  ? 565
                                  : 230,
                              width: double.infinity,
                              child: image,
                            ),
                            Opacity(
                              opacity: isHeartAnimating ? 1 : 0,
                              child: ScaleTransition(
                                scale: scale,
                                child: Icon(
                                  Icons.favorite,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 200,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  }
                },
              ),

              // Like and Comment Section
              Padding(
                padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          TextButton.icon(
                            label: SubHeading(
                                str: '${widget.post.numLikes} Likes'),
                            onPressed: likeHandler,
                            icon: isLiked
                                ? Icon(
                                    Icons.favorite,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 32,
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                          ),
                          Spacer(),
                          TextButton.icon(
                            label: SubHeading(
                              str: '${widget.post.numComments} Comments',
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: ((context) =>
                                      CommentsSheet(widget.post.id)),
                                  showDragHandle: true,
                                  enableDrag: true,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary);
                            },
                            icon: Icon(
                              Icons.comment_outlined,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      showFullCaption = !showFullCaption;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 8.0, left: 5, right: 5, bottom: 22),
                    child: SubHeading(
                      str: showFullCaption
                          ? widget.post.capion
                          : (widget.post.capion.length > 100
                              ? widget.post.capion.substring(0, 100) + "..."
                              : widget.post.capion),
                      align: TextAlign.center,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
