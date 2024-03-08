import 'dart:io';

import 'package:fests/screens/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fests/providers/userProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends ConsumerStatefulWidget {
  UpdateProfile({super.key});
  @override
  ConsumerState<UpdateProfile> createState() => _LoginState();
}

class _LoginState extends ConsumerState<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _rollno, _name, _bio, _github, _linkdlin, _cp;
  void _update() {
    if (_formKey.currentState!.validate()) {
      ref.read(userProvider.notifier).updateProfile(
          name: _name,
          email: _email,
          rollno: _rollno,
          bio: _bio,
          cp: _cp,
          github: _github,
          linkdlin: _linkdlin,
          dp: selectedImage);
      Navigator.pop(context);
    }
  }

  File? selectedImage = null;
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final dp = user!.avatar == null
        ? AssetImage("assets/images/profile.png")
        : NetworkImage(user.avatar!);
    void takePicture(String pickMode) async {
      final imagePicker = ImagePicker();
      final pickedImage;
      if (pickMode == "gallery") {
        pickedImage = await imagePicker.pickImage(
            source: ImageSource.gallery, maxWidth: 600);
      } else {
        pickedImage = await imagePicker.pickImage(
            source: ImageSource.camera, maxWidth: 600);
      }
      if (pickedImage == null) {
        return;
      }
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }

    return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.background),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          onTap: () => takePicture("camara"),
                          onLongPress: () => takePicture("gallery"),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: selectedImage == null
                                    ? dp as ImageProvider
                                    : FileImage(selectedImage!)
                                        as ImageProvider,
                                radius: 70,
                              ),
                              if (user.avatar == null && selectedImage == null)
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: SubHeading(
                                      str:
                                          "Tap me for camara\nLong Press me for gallery",
                                      align: TextAlign.center,
                                      color: Colors.red,
                                    ))
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          initialValue: user!.name,
                          onChanged: (value) {
                            _name = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return 'name is a required feild';
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Name",
                              style: TextStyle(color: Colors.white),
                            ),
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          initialValue: user.rollno,
                          onChanged: (value) {
                            _rollno = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return 'roll number is a required feild';
                            }
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Icon(
                              Icons.school,
                              color: Colors.white,
                            ),
                            label: Text("Roll Number",
                                style: TextStyle(color: Colors.white)),
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          initialValue: user.email,
                          onChanged: (value) {
                            _email = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return 'email is a required feild';
                            }
                            if (!value.contains('@')) {
                              return 'enter valid e mail';
                            }
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            label: Text("E Mail",
                                style: TextStyle(color: Colors.white)),
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          maxLines: 5,
                          initialValue: user.bio,
                          onChanged: (value) {
                            _bio = value;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.description,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Bio",
                              style: TextStyle(color: Colors.white),
                            ),
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          initialValue: user.socialLinks != null
                              ? user.socialLinks!["github"]
                              : "",
                          onChanged: (value) {
                            _github = value;
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Icon(
                              FontAwesomeIcons.github,
                              color: Colors.white,
                            ),
                            label: Text("Github",
                                style: TextStyle(color: Colors.white)),
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          initialValue: user.socialLinks != null
                              ? user.socialLinks!["linkdlin"]
                              : "",
                          onChanged: (value) {
                            _linkdlin = value;
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Icon(
                              FontAwesomeIcons.linkedin,
                              color: Colors.white,
                            ),
                            label: Text("Linkdlin",
                                style: TextStyle(color: Colors.white)),
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          initialValue: user.socialLinks != null
                              ? user.socialLinks!["codingPlatform"]
                              : "",
                          onChanged: (value) {
                            _cp = value;
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Icon(
                              FontAwesomeIcons.code,
                              color: Colors.white,
                            ),
                            label: Text("Any Compitative Coding Platform",
                                style: TextStyle(color: Colors.white)),
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _update,
                          child: Heading(
                            str: "Update",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
