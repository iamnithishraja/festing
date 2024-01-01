import 'package:dio/dio.dart';
import 'package:fests/globals/constants.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword(this.id, {super.key});
  final id;
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  String? _password, _confirmPassword;
  bool _isConfirmPasswordVisible = false, _isPasswordVisible = false;
  bool isEnabled = true;
  void _onChangePassword() async {
    isEnabled = false;
    if (_formKey.currentState!.validate()) {
      if (_password == _confirmPassword) {
        final response = await http.putForm(
            "$baseUrl/user/password/reset/${widget.id}",
            "application/json",
            FormData.fromMap(
                {"password": _password, "confirmPassword": _confirmPassword}));
        if (response!["success"]) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(
              msg: "changed password",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 3,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(context);
        } else {
          Fluttertoast.cancel();
          Fluttertoast.showToast(
              msg: response["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              timeInSecForIosWeb: 3,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
            msg: "passwords are not same",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            timeInSecForIosWeb: 3,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
    isEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.background),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
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
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        onChanged: (value) {
                          _password = value;
                        },
                        validator: (value) {
                          if (value == null || value.trim() == '') {
                            return 'password is a required feild';
                          }
                          if (value.length < 8) {
                            return 'please enter at least 8 characters';
                          }
                        },
                        obscureText: _isPasswordVisible ? false : true,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(
                                _isPasswordVisible
                                    ? Icons.remove_red_eye_rounded
                                    : Icons.remove_red_eye_outlined,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.password,
                            color: Colors.white,
                          ),
                          label: Text("Password",
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
                        onChanged: (value) {
                          _confirmPassword = value;
                        },
                        validator: (value) {
                          if (value == null || value.trim() == '') {
                            return 'Confirm password is a required feild';
                          }
                          if (value.length < 8) {
                            return 'please enter at least 8 characters';
                          }
                        },
                        obscureText: _isConfirmPasswordVisible ? false : true,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.remove_red_eye_rounded
                                    : Icons.remove_red_eye_outlined,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          label: Text("Confirm Password",
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
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: isEnabled ? _onChangePassword : null,
                        child: Heading(
                          str: "change password",
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
              )),
        ),
      ),
    );
  }
}
