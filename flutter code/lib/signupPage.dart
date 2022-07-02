import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:problock/homepage.dart';
import 'package:problock/main.dart';
import 'package:problock/signup_forms/signup_custo.dart';
import 'package:problock/signup_forms/signup_man.dart';
import 'package:problock/signup_switch.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isManu = true;
  final nameController = TextEditingController();
  final locController = TextEditingController();
  final emailController = TextEditingController();
  final pnoController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();
  int registerCustomer() {
    if (nameController.text == "" || emailController.text == "") {
      return -1;
    }
    FirebaseFirestore.instance
        .collection('USERS')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .set({
      'user': "c",
      'userFireid': "${FirebaseAuth.instance.currentUser!.uid}",
      'name': nameController.text,
      'location': locController.text,
      'email': emailController.text,
      'phone': pnoController.text,
      'address': addressController.text,
      'dob': dobController.text
    });
    return 0;
  }

  int registerMan() {
    if (nameController.text == "" || emailController.text == "") {
      return -1;
    }
    FirebaseFirestore.instance
        .collection('USERS')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .set({
      'user': "m",
      'userFireid': "${FirebaseAuth.instance.currentUser!.uid}",
      'name': nameController.text,
      'location': locController.text,
      'email': emailController.text,
      'phone': pnoController.text,
    });
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFFCFCFC),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height:50,
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        'Looks like you are a new user.',
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8954E7)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                 SizedBox(
                  height:50,
                ),
                SignupSwitch(
                  isManu: isManu,
                  onTap: () {
                    setState(() {
                      isManu = !isManu;
                    });
                  },
                ),
                 SizedBox(
                  height:50,
                ),
                isManu
                    ? SignupFormMan(
                        nameController: nameController,
                        pnoController: pnoController,
                        emailController: emailController,
                        locController: locController,
                      )
                    : SignupFormCust(
                        nameController: nameController,
                        pnoController: pnoController,
                        emailController: emailController,
                        locController: locController,
                        addressController: addressController,
                        dobController: dobController,
                      ),
                      SizedBox(
                  height:80,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      int flag = 0;
                      if (isManu) {
                        flag = registerMan();
                      } else {
                        flag = registerCustomer();
                      }
                      // await GoogleSignInProvider().googleLogin();
          
                      if (flag == 0) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) =>  homePage()));
                      }
                    },
                    child: Text('Sign Up'),
                    style: ElevatedButton.styleFrom(
                        primary: Color(0XFF8954E7),
                        textStyle:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
