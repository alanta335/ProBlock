import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:problock/createblock.dart';
import 'package:problock/main.dart';
import 'package:problock/profile_components/CountItem.dart';
import 'package:problock/qrscan.dart';

class ProfilePage extends StatefulWidget {
  var userData;
  ProfilePage(this.userData, {Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  CircleAvatar(
                    radius: 85,
                    backgroundColor: Color(0xff8954e7),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        "${FirebaseAuth.instance.currentUser?.photoURL}",
                      ),
                      radius: 80,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.userData['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              CountItem(count: "72", text: "Total items owned"),
              CountItem(count: "12", text: "Total items owned"),
              CountItem(count: "24", text: "Total items owned"),
            ]),
            SizedBox(
              height: 100,
            ),
            ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.edit),
                label: Text('Edit Profile')),
            ElevatedButton.icon(
                onPressed: () {
                  if (widget.userData['user'] == 'm') {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) => CreBlock()));
                  } else {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) => QrScan()));
                  }
                },
                icon: Icon(Icons.qr_code_scanner_outlined),
                label: Text('Scan')),
            ElevatedButton(
                onPressed: () async {
                  await GoogleSignInProvider().loggedout(context);
                },
                child: Text('Logout'))
          ],
        ),
      ),
    );
  }
}
