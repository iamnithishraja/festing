import 'package:fests/models/fest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:fests/providers/festProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:fests/widgets/texts/heading_text.dart';

class CreateFest extends ConsumerStatefulWidget {
  const CreateFest({super.key});
  final route = "/fests/create";

  @override
  ConsumerState<CreateFest> createState() => _CreateFestState();
}

class _CreateFestState extends ConsumerState<CreateFest> {
  final _formKey = GlobalKey<FormState>();
  String? _collegeName,
      _festName,
      _description,
      _collegeWebsite,
      _festWebsite,
      _location,
      _startDate,
      _endDate,
      _festBroture,
      _toEndDate,
      _toStartDate;

  File? selectedImage = null;
  @override
  Widget build(BuildContext context) {
    void takePicture() async {
      final imagePicker = ImagePicker();
      final pickedImage = await imagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 600);
      if (pickedImage == null) {
        return;
      }
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }

    void datePicker(String selected) async {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 2),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Theme.of(context).colorScheme.secondary,
                  onPrimary: Colors.white,
                  surface: Theme.of(context).colorScheme.secondary,
                ),
                dialogTheme: DialogTheme(
                  backgroundColor: const Color.fromRGBO(15, 15, 15, 1),
                  shape: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                )),
            child: child!,
          );
        },
      );
      setState(() {
        if (selected == "start" && pickedDate != null) {
          _startDate = pickedDate
              .toString()
              .substring(0, 10)
              .split('-')
              .reversed
              .join("-");
          _toStartDate = pickedDate.toString();
        } else if (pickedDate != null) {
          _endDate = pickedDate
              .toString()
              .substring(0, 10)
              .split('-')
              .reversed
              .join("-");
          _toEndDate = pickedDate.toString();
        }
      });
    }

    void _submitForm() {
      if (_formKey.currentState!.validate()) {
        ref.read(festProvider.notifier).createFest(
              collegeName: _collegeName!,
              festName: _festName!,
              collegeWebsite: _collegeWebsite!,
              description: _description!,
              location: _location!,
              startDate: _toStartDate!.split(' ')[0],
              endDate: _toEndDate!.split(' ')[0],
              poster: selectedImage!,
              broture: _festBroture!,
              festWebsite: _festWebsite,
            );
        Navigator.of(context).pop();
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: "success new fest will be created soon",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (_toEndDate == null || _toStartDate == null || selectedImage == null) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: "required feilds are missing",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Fest"),
      ),
      body: Container(
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.background),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          onChanged: (value) {
                            _collegeName = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return 'college name is a required feild';
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.account_balance,
                              color: Colors.white,
                            ),
                            label: Text(
                              "College Name",
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
                          onChanged: (value) {
                            _festName = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return 'fest name is a required feild';
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.local_activity,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Fest Name",
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
                          maxLines: 8,
                          onChanged: (value) {
                            _description = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return 'description is a required feild';
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.description,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Description",
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
                          onChanged: (value) {
                            _collegeWebsite = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return 'college website is a required feild';
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.web,
                              color: Colors.white,
                            ),
                            label: Text(
                              "College Website",
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
                          onChanged: (value) {
                            _festWebsite = value;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.webhook,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Fest Website",
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
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return "cannot be empty";
                            }
                          },
                          onChanged: (value) {
                            _festBroture = value;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.add_to_drive_rounded,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Brochure URL",
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
                          onChanged: (value) {
                            _location = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return 'location is a required feild';
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Location",
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
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => datePicker("start"),
                              icon: Icon(Icons.calendar_month),
                            ),
                            SubHeading(
                                str: _startDate == null
                                    ? "start date"
                                    : _startDate!),
                            Spacer(),
                            SubHeading(
                                str: _endDate == null ? "end date" : _endDate!),
                            IconButton(
                              onPressed: () => datePicker("end"),
                              icon: Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            height: 200,
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
                                    ),
                                  ),
                          )),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: Heading(
                            str: "Create",
                            fontSize: 28,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
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
