import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/models/User.dart';
import 'package:notes/pages/Dashboard.dart';
import 'package:notes/pages/Register.dart';
import 'package:notes/service/AuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      // : Image(image: ""),
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage("assets/login.jpg"),
      //     fit: BoxFit.cover
      //   ),
      // ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: [
                // Image.asset("assets/login.jpg", fit: BoxFit.cover,),
                Container(child: Image.asset("assets/login.jpg")),
                Container(
                  padding: EdgeInsets.only(top: 30, left: 35, right: 35),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userEmail,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Email";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            // fillColor: Colors.white,
                            // filled: true,
                            hintText: "Email",
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(color: Colors.red)
                            // ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: userPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Email";
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                    padding: EdgeInsets.only(left: 35, right: 35),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  CupertinoPageRoute(builder: (context) {
                                return const Register();
                              }));
                            },
                            child: Text(
                              "Register Now",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                User user = new User(userEmail: userEmail.text, userPassword: userPassword.text, userFirstName: "", userLastName: "");
                                var result = await AuthService.loginUser(user);
                                if (result != "Invalid Credentials") {
                                  var data = jsonEncode(result);
                                  var id = jsonDecode(data)["uniqueId"];
                                  var userData = jsonDecode(data);
                                  var userFirstNameValue = jsonDecode(data)["userFirstName"];
                                  var userLastNameValue = jsonDecode(data)["userLastName"];
                                  var userEmailValue = jsonDecode(data)["userEmail"];
                                  if(id.runtimeType == String){
                                    print("Object");
                                    print(id.runtimeType);
                                    var sharedPref = await SharedPreferences.getInstance();
                                    sharedPref.setBool('Login', true);
                                    sharedPref.setString("id", id);
                                    // sharedPref.setStringList("data", [id, userFirstNameValue, userLastNameValue, userEmailValue, "User"]);

                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                      return new Dashboard(id: id);
                                    }));
                                  }
                                }else{
                                  Fluttertoast.showToast(msg: result.toString(), backgroundColor: Colors.red, textColor: Colors.white, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2, fontSize: 18.0);
                                }
                              }
                            },
                            child: Text("Login"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              primary: Colors.green,
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          )
                        ]))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
