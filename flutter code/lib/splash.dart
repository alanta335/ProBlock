import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:problock/history2.dart';
import 'package:problock/homepage.dart';
import 'package:problock/main.dart';
import 'package:problock/qrscan.dart';
import 'package:problock/signupPage.dart';

import 'getStarted.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    goTo(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    children: [
                      TextSpan(text: "Pro"),
                      TextSpan(
                          text: "B",
                          style: TextStyle(
                              color: Color.fromRGBO(137, 84, 231, 1))),
                      TextSpan(text: "lock"),
                    ]),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}

Future<void> goTo(BuildContext context) async {
  await Future.delayed(Duration(seconds: 2));
  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => GetStarted()));
}
