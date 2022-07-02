

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
// ignore_for_file: prefer_const_constructors

import 'package:http/http.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  // Future<List<Widget>>
  @override
  Widget build(BuildContext context) {
    Query users = FirebaseFirestore.instance
        .collection('USERS')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .collection('devices')
        .orderBy('timestamp');

    print(FirebaseAuth.instance.currentUser!.uid);
    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return Scaffold(
          body: ListView(
            addAutomaticKeepAlives: false,
            cacheExtent: 300,
            reverse: false,
            //physics: ,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return ExpansionTile(
                title: Text(
                  "Device number ${document.get('serial_no')}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://www.cbj.ca/wp-content/uploads/2018/12/Sunder-Pichai1.jpg")),
                children: <Widget>[
                  ListTile(
                    title: const Text('Hell'),
                    subtitle: Text("Series Number"),
                    trailing: Container(
                        child: IconButton(
                            onPressed: () {}, icon: Icon(Icons.arrow_forward))),
                  )
                ],
              );
            }).toList(),
          ),
        );
      },
    );
    //     appBar: AppBar(title: Text("History")),
    //     body: Builder(builder: (context) {
    //       return ListView.separated(
    //           itemBuilder: (BuildContext context, int index) {
    //             return ExpansionTile(
    //               title: Text(
    //                 "Name $index",
    //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
    //               ),
    //               leading: CircleAvatar(
    //                   backgroundImage: NetworkImage(
    //                       "https://www.cbj.ca/wp-content/uploads/2018/12/Sunder-Pichai1.jpg")),
    //               children: <Widget>[
    //                 ListTile(
    //                   title: const Text("Manufacture Name"),
    //                   subtitle: Text("Series Number"),
    //                   trailing: Container(
    //                       child: IconButton(
    //                           onPressed: () {
    //                             getArr();
    //                           },
    //                           icon: Icon(Icons.arrow_forward))),
    //                 )
    //               ],
    //             );
    //           },
    //           separatorBuilder: (BuildContext context, int index) =>
    //               const Divider(),
    //           itemCount: 10);
    //     }),
    //   );
    // }
  }
}

