import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fests/providers/postProvider.dart';
import 'package:fests/widgets/texts/heading_text.dart';
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
  String _category = "others";

  void takePicture() async {
    final imagePicker = ImagePicker();
    // TODO: add width in cas of heavy file size
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery,maxWidth: 1920);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      selectedImage = File(pickedImage.path);
    });
  }

  void createPost() {
    if (selectedImage != null) {
      ref
          .read(userpostsProvider.notifier)
          .createNewPost(selectedImage!, _caption, _category);
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "please select picture",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    Navigator.of(context).pop();
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
      backgroundColor: Theme.of(context).colorScheme.background,
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
            FutureBuilder(
              future: ref.read(userpostsProvider.notifier).getAllCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(
                    color: Colors.white,
                  );
                }
                if (snapshot.data!.length <= 1) {
                  return Container();
                }
                return Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Theme(
                    data: ThemeData.dark(),
                    child: DropdownButton(
                      value: _category,
                      dropdownColor: Theme.of(context).colorScheme.onBackground,
                      items: snapshot.data!.map((cat) {
                        return DropdownMenuItem(
                          child: SubHeading(str: cat),
                          value: cat,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _category = value!;
                        });
                      },
                      underline: Container(),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 25),
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: createPost,
                child: Heading(
                  str: "CREATE",
                  fontSize: 28,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(97, 63, 216, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
