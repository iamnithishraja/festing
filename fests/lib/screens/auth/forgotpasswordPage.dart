import 'package:fests/globals/constants.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class forgotPasswordScreen extends StatefulWidget {
  const forgotPasswordScreen({super.key});

  @override
  State<forgotPasswordScreen> createState() => _forgotPasswordScreenState();
}

class _forgotPasswordScreenState extends State<forgotPasswordScreen> {
  final _emailController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    super.dispose();
  }

  bool isEnabled = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(str: "Forgot Password"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _emailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      label:
                          Text("Email", style: TextStyle(color: Colors.white)),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: isEnabled
                        ? () async {
                            setState(() {
                              isEnabled = false;
                            });
                            final response = await http.postBody(
                                "$baseUrl/user/password/forgotpassword",
                                "application/json",
                                {"email": _emailController.text});
                            _emailController.text = "";
                            if (response["success"]) {
                              Fluttertoast.showToast(
                                  msg: "Sent recovery Email",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.green,
                                  timeInSecForIosWeb: 3,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Navigator.of(context).pop();
                            } else {
                              Fluttertoast.showToast(
                                  msg: response["message"],
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  timeInSecForIosWeb: 3,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            setState(() {
                              isEnabled = true;
                            });
                          }
                        : null,
                    child: Heading(
                      str: "Send Recovery Email",
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
      ),
    );
  }
}
