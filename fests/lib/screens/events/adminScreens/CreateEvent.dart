import 'package:fests/models/fest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:fests/providers/eventProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/form/detailsAdder.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CreateEvent extends ConsumerStatefulWidget {
  CreateEvent(this.fest, {super.key});
  Fest fest;
  @override
  ConsumerState<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends ConsumerState<CreateEvent> {
  final _formKey = GlobalKey<FormState>();
  String? _eventName, _description, _category, _venue, _location;
  bool _isLimitedNumberOfTeams = false;
  int? _teamSize, _price;
  List<String>? details = [];
  File? selectedImage = null;

  DateTime? _startDate, _endDate;
  List<List<DateTime>> timings = [];
  List<List<Widget>> timingsSetters = [];
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
          _startDate = pickedDate;
        } else if (pickedDate != null) {
          _endDate = pickedDate;
        }
      });
    }

    void timepicker(int i, int j) async {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(),
            child: child!,
          );
        },
      );
      if (time == null) {
        return;
      }
      setState(() {
        timings[i][j] = DateTime(timings[i][j].year, timings[i][j].month,
            timings[i][j].day, time.hour, time.minute);
        timingsSetters[i][j] = TextButton.icon(
          onPressed: () => timepicker(i, j),
          icon: Icon(
            Icons.watch_later,
            color: Colors.white,
          ),
          label: SubHeading(
            str: timings[i][j].hour >= 12
                ? timings[i][j].hour == 12
                    ? "${timings[i][j].hour.toString()}:${timings[i][j].minute.toString()} pm"
                    : "${(timings[i][j].hour - 12).toString()}:${timings[i][j].minute.toString()} pm"
                : "${timings[i][j].hour.toString()}:${timings[i][j].minute.toString()} am",
          ),
        );
      });
    }

    if (_startDate != null && _endDate != null) {
      int numDays = _endDate!.difference(_startDate!).inDays + 1;
      if (numDays < timings.length) {
        timings = [];
        timingsSetters = [];
      }
      for (var i = 0; i < numDays; i++) {
        if (i >= timings.length) {
          timings.add([
            DateTime(_startDate!.year, _startDate!.month, _startDate!.day + i),
            DateTime(_startDate!.year, _startDate!.month, _startDate!.day + i)
          ]);
          timingsSetters.add([
            TextButton.icon(
              onPressed: () => timepicker(i, 0),
              icon: Icon(
                Icons.watch_later,
                color: Colors.white,
              ),
              label: SubHeading(
                  str: timings[i][0].hour == 0
                      ? "start time"
                      : timings[i][0].hour.toString()),
            ),
            TextButton.icon(
              onPressed: () => timepicker(i, 1),
              icon: Icon(
                Icons.watch_later,
                color: Colors.white,
              ),
              label: SubHeading(
                  str: timings[i][1].hour == 0
                      ? "end time"
                      : timings[i][1].hour.toString()),
            ),
          ]);
        }
      }
    }

    void _submitForm() {
      if (!_formKey.currentState!.validate()) return;
      if (details == null ||
          details!.isEmpty ||
          _startDate == null ||
          _endDate == null ||
          selectedImage == null) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
            msg: "required feilds are missing",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
      ref.read(eventProvider.notifier).createEvent(
          festId: widget.fest.id,
          eventName: _eventName!,
          description: _description!,
          details: details!,
          price: _price!,
          teamSize: _teamSize!,
          poster: selectedImage!,
          category: _category!,
          venue: _venue!,
          location: _location!,
          schedule: timings,
          isLimitedNumberOfTeams: _isLimitedNumberOfTeams);
      details = [];
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Event"),
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
                          style: TextStyle(color: Colors.white),
                          onChanged: (value) {
                            _eventName = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return 'event name is a required feild';
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.emoji_events,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Event Name",
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
                          maxLines: 5,
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
                      DetailsAdder(details),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          onChanged: (value) {
                            _category = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return 'category required feild';
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.category,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Category",
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
                          onChanged: (value) {
                            _venue = value;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.pin_drop,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Venue",
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
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return "location cannot be empty";
                            }
                          },
                          onChanged: (value) {
                            _location = value;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Location URL",
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
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                onChanged: (value) {
                                  _teamSize = int.tryParse(value);
                                },
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.trim() == '') {
                                    return 'teamSize is a required feild';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "teamsize must be integer";
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.group,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Team Size",
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
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                onChanged: (value) {
                                  _price = int.tryParse(value);
                                },
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.trim() == '') {
                                    return 'price is a required feild';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "price must be integer";
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.attach_money,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Price",
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
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => datePicker("start"),
                              icon: Icon(Icons.calendar_month),
                            ),
                            SubHeading(
                                str: _startDate == null
                                    ? "start date"
                                    : DateFormat("dd-MM-yyy")
                                        .format(_startDate!)),
                            Spacer(),
                            SubHeading(
                                str: _endDate == null
                                    ? "end date"
                                    : DateFormat("dd-MM-yyy")
                                        .format(_endDate!)),
                            IconButton(
                              onPressed: () => datePicker("end"),
                              icon: Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                      ...timingsSetters.map(
                        (timePickerPairs) {
                          return Row(
                            children: [
                              timePickerPairs[0],
                              Spacer(),
                              Icon(Icons.arrow_forward, size: 28),
                              Spacer(),
                              timePickerPairs[1],
                            ],
                          );
                        },
                      ).toList(),
                      SizedBox(
                        height: 10,
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
                      Row(
                        children: [
                          SubHeading(str: "Limited number of Teams?"),
                          Switch(
                            value: _isLimitedNumberOfTeams,
                            inactiveTrackColor: Colors.grey,
                            onChanged: (bool value) {
                              setState(() {
                                _isLimitedNumberOfTeams = value;
                              });
                            },
                          )
                        ],
                      ),
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
