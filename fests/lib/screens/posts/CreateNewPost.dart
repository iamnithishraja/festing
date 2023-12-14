import 'dart:io';

import 'package:fests/providers/postProvider.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateNewPost extends ConsumerStatefulWidget {
  const CreateNewPost({super.key});

  @override
  ConsumerState<CreateNewPost> createState() => _CreateNewPostState();
}

class _CreateNewPostState extends ConsumerState<CreateNewPost> {
  File? selectedImage = null;
  String _caption = "";
  String _category = "";

  void takePicture() async {
    final imagePicker = ImagePicker();
    // TODO: add width in cas of heavy file size
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      selectedImage = File(pickedImage.path);
    });
  }

  List<String> categories = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref
        .read(postProvider.notifier)
        .getAllCategories()
        .then((value) => categories = value);
  }

  @override
  Widget build(BuildContext context) {
    var imgHeight = 200;
    if (selectedImage != null) {
      final img = ImageSizeGetter.getSize(FileInput(selectedImage!));
      if (img.height > img.width) {
        imgHeight = 600;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Post"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: imgHeight.toDouble(),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      )),
                  child: selectedImage == null
                      ? TextButton.icon(
                          onPressed: takePicture,
                          icon: Icon(
                            Icons.camera,
                            color: Colors.white,
                          ),
                          label: SubHeading(
                            str: "Select Picture",
                            color: Colors.white,
                          ),
                        )
                      : GestureDetector(
                          onTap: takePicture,
                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.fill,
                            height: imgHeight.toDouble(),
                          ),
                        ),
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                maxLines: 3,
                onChanged: (value) {
                  _caption = value;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.description,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Caption",
                    style: TextStyle(color: Colors.white),
                  ),
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            DropdownButton(
              items: categories
                  .map((cat) => DropdownMenuItem(
                        child: SubHeading(str: cat),
                        value: UniqueKey(),
                      ))
                  .toList(),
              onChanged: (value) {
                // setState(() {
                //   _category = value!;
                // });
              },
            )
          ],
        ),
      ),
    );
  }
}
