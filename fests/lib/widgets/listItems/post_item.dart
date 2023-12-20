import 'dart:async';

import 'package:fests/widgets/listItems/useritems/orderuser_item.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

class PostItem extends StatefulWidget {
  PostItem({
    this.profileImage,
    required this.username,
    required this.postImage,
    required this.caption,
    required this.numLikes,
    required this.numComments,
    required this.rollno,
  });
  final String? profileImage;
  final String username;
  final String postImage;
  final String caption;
  final int numLikes;
  final String rollno;
  final int numComments;

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool showFullCaption = false;
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
                    return Container(
                      height: snapshot.data.height > snapshot.data.width
                          ? 600
                          : 230,
                      width: double.infinity,
                      child: image,
                    );
                  } else {
                    return CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    );
                  }
                },
              ),

              // Caption
              GestureDetector(
                  onTap: () {
                    setState(() {
                      showFullCaption = !showFullCaption;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, left: 8),
                    child: SubHeading(
                      str: showFullCaption
                          ? widget.caption
                          : (widget.caption.length > 100
                              ? widget.caption.substring(0, 100) + "..."
                              : widget.caption),
                      align: TextAlign.center,
                    ),
                  )),

              // Like and Comment Section
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.favorite),
                          SizedBox(width: 4.0),
                          SubHeading(str: '${widget.numLikes} Likes'),
                          Spacer(),
                          SubHeading(str: '${widget.numComments} Comments'),
                          SizedBox(width: 4.0),
                          Icon(Icons.comment),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
