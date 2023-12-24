import 'package:fests/providers/postProvider.dart';
import 'package:fests/providers/userProvider.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentsSheet extends ConsumerStatefulWidget {
  CommentsSheet(this.postId, {super.key});
  String postId;
  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final _commentController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: ref
                  .read(postsProvider.notifier)
                  .getPostComments(widget.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ...snapshot.data!["comments"].map((comment) {
                        final dp = comment["dp"] == null
                            ? AssetImage("assets/images/profile.png")
                            : NetworkImage(comment["dp"]);
                        return Card(
                          margin: EdgeInsets.only(bottom: 20),
                          shadowColor: Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: dp as ImageProvider,
                              radius: 30,
                            ),
                            minVerticalPadding: 10,
                            tileColor: Theme.of(context).colorScheme.background,
                            title: Heading(
                              str: comment["username"],
                              fontSize: 18,
                            ),
                            subtitle: SubHeading(
                              str: comment["comment"],
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList()
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(
                          Icons.comment,
                          color: Colors.white,
                        ),
                        label: Text("Comment",
                            style: TextStyle(color: Colors.white)),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        ref.read(postsProvider.notifier).commentOnPost(
                            widget.postId, _commentController.text);
                        _commentController.text = "";
                      });
                    },
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 28,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
