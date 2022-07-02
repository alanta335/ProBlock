import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:problock/homepage.dart';
import 'package:problock/main.dart';
import 'package:problock/signupPage.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.325,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: new DecorationImage(
                    image: ExactAssetImage('lib/assets/img.png'),
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Color(0xff8954e7)),
              child: SvgPicture.asset(
                '/lib/assets/img.svg',
                width: 100,
                height: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Text(
                  "A modern product authentication application with the security and power of blockchain.!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xff8954e7)),
                      onPressed: () async {
                        int flag = await GoogleSignInProvider().googleLogin();
                        if (flag == 0) {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx) => homePage()));
                        } else {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx) => Signup()));
                        }
                      },
                      child: Text("Login Using Google")),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
