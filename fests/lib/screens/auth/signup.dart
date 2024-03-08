import 'package:fests/screens/fests/userScreens/fest.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:fests/screens/auth/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fests/providers/userProvider.dart';

class SignUp extends ConsumerStatefulWidget {
  SignUp({Key? key, required this.callBack}) : super(key: key);
  final route = "/signup";
  void Function() callBack;
  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _rollno, _password;
  bool _isSignupButtonEnabled = true;
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    if (user != null) {
      Navigator.of(context).pushReplacementNamed(Fests().route);
    }

    void _onSignUp() async {
      setState(() {
        _isSignupButtonEnabled = false;
      });
      if (_formKey.currentState!.validate()) {
        await ref.read(userProvider.notifier).register(
              _name!.trim(),
              _email!.trim(),
              _rollno!.trim().toUpperCase(),
              _password!.trim(),
            );
      }
      setState(() {
        _isSignupButtonEnabled = true;
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
            children: [
              SubHeading(str: "Hey There"),
              SizedBox(height: 8),
              Heading(str: "Create An Account"),
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
                          style: TextStyle(color: Colors.white),
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
                          onChanged: (value) {
                            _email = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return 'email is a required feild';
                            }
                            if (!value.contains('@')) {
                              return 'enter valid Email';
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
                          style: TextStyle(color: Colors.white),
                          onChanged: (value) {
                            _password = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim() == '') {
                              return 'password is a required feild';
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
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _isSignupButtonEnabled ? _onSignUp : null,
                          child: Heading(
                            str: "Sign Up",
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
                str: "Alredy Have Account?",
              ),
              TextButton(
                onPressed: widget.callBack,
                child: SubHeading(
                  str: "Login",
                  color: Colors.blueAccent,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
