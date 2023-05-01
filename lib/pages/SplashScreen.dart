import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/pages/Dashboard.dart';
import 'package:notes/pages/Login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    validateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          margin: const EdgeInsets.only(top: 40),
          child: Center(
            child: SizedBox(
              child: Center(
                  child: TextLiquidFill(
                    boxBackgroundColor: Colors.black,
                    text: "iNote",
                    textStyle: GoogleFonts.acme(
                      letterSpacing: .4,
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                    ),
                    waveColor: Colors.white,
                    waveDuration: const Duration(seconds: 2),
                    loadDuration: const Duration(seconds: 3),
                  ),
                  ),
            ),
          ),
        ));
  }

  validateUser() {
    Timer(const Duration(milliseconds: 3500), () async {
      var result = await SharedPreferences.getInstance();
      var data = result.getBool("Login");
      var id = result.getString("id");

      if (data!) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Dashboard(id: id);
        }));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const Login();
        }));
      }
    });
  }
}
