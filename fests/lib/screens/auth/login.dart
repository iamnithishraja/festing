import 'package:fests/screens/auth/forgotpasswordPage.dart';
import 'package:fests/screens/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fests/providers/userProvider.dart';

class Login extends ConsumerStatefulWidget {
  Login({super.key, required this.callBack});
  void Function() callBack;
  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  String? _email, _password;
  void _login() {
    if (_formKey.currentState!.validate()) {
      ref.read(userProvider.notifier).login(_email!.trim(), _password!.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.background),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SubHeading(str: "Welcome Back"),
              SizedBox(height: 8),
              Heading(str: "Log In"),
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle),
              ),
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
                            _email = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return 'E-mail is a required feild';
                            }
                            if (!value.contains('@')) {
                              return 'Enter valid E-mail';
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
                            label: Text("E-Mail",
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
                            _password = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return 'Password is a required feild';
                            }
                            if (value.length < 8) {
                              return 'Please enter at least 8 characters';
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
                      Row(
                        children: [
                          Spacer(),
                          TextButton(
                              onPressed: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        forgotPasswordScreen(),
                                  )),
                              child: SubHeading(
                                str: "Forgot password ?",
                                color: Colors.blueAccent,
                              )),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _login,
                          child: Heading(
                            str: "Log In",
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
              SubHeading(
                str: "Don't Have an Account ?",
              ),
              TextButton(
                  onPressed: widget.callBack,
                  child: SubHeading(
                    str: "Sign Up",
                    color: Colors.blueAccent,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
