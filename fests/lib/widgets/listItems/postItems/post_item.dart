import 'dart:async';
import 'package:fests/providers/postProvider.dart';
import 'package:fests/widgets/listItems/comments.dart';
import 'package:fests/widgets/listItems/useritems/orderuser_item.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_size_getter/image_size_getter.dart';

class PostItem extends ConsumerStatefulWidget {
  PostItem({
    this.profileImage,
    required this.username,
    required this.postImage,
    required this.caption,
    required this.numLikes,
    required this.numComments,
    required this.rollno,
    required this.isLiked,
    required this.id,
  });
  final String? profileImage;
  final String username;
  final String postImage;
  final String caption;
  int numLikes;
  final String id;
  final String rollno;
  final int numComments;
  final bool isLiked;
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends ConsumerState<PostItem>
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
    isLiked = widget.isLiked;
    scale = Tween<double>(begin: 0, end: 2).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final dp = widget.profileImage == null
        ? AssetImage("assets/images/profile.png")
        : NetworkImage(widget.profileImage!);

    Image image = Image.network(
      widget.postImage,
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
          widget.numLikes++;
          _controller.forward().then((value) {
            _controller.reverse().then((value) {});
          });
        } else {
          widget.numLikes--;
        }
      });
      ref.read(postsProvider.notifier).likeunlikePost(widget.id);
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
          )),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: Theme.of(context).colorScheme.secondary,
        color: Theme.of(context).colorScheme.primary,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
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
                    str: widget.username,
                    fontSize: 18,
                  ),
                ),
                subtitle: Transform.translate(
                  offset: Offset(-8, 0),
                  child: SubHeading(
                    str: widget.rollno,
                    fontSize: 14,
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
                            label: SubHeading(str: '${widget.numLikes} Likes'),
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
                              str: '${widget.numComments} Comments',
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: ((context) =>
                                      CommentsSheet(widget.id)),
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
                    padding:
                        EdgeInsets.only(top: 8.0, left: 5, right: 5, bottom: 8),
                    child: SubHeading(
                      str: showFullCaption
                          ? widget.caption
                          : (widget.caption.length > 100
                              ? widget.caption.substring(0, 100) + "..."
                              : widget.caption),
                      align: TextAlign.center,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
