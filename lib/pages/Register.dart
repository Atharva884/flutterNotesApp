import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/User.dart';
import 'package:notes/pages/Login.dart';
import 'package:notes/service/AuthService.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Key For Form
  final _formKey = GlobalKey<FormState>();

  // TextEditing 
  TextEditingController userFirstName = TextEditingController();
  TextEditingController userLastName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword= TextEditingController();


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
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Image.asset("assets/register.jpg")
                ),
                Container(
                  padding: EdgeInsets.only(top: 40, left: 35, right: 35),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userFirstName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your First Name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "First Name",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: userLastName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your Last Name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Last Name",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: userEmail,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your Email";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Email",
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
                            return "Enter Password";
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
                                return const Login();
                              }));
                            },
                            child: Text(
                              "Login Now",
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
                                User user = new User(userFirstName: userFirstName.text, userLastName: userLastName.text, userEmail: userEmail.text, userPassword: userPassword.text);
                                var result = await AuthService.registerUser(user);

                                if(result == "Registered"){
                                  Fluttertoast.showToast(      
                                      msg: "You have been Registered Successfully",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 18.0
                                  );

                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                    return const Login();
                                  }));
                                }
                              }
                            },
                            child: Text("Register"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
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
