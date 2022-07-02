import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import 'package:path_provider/path_provider.dart';

class QrGen extends StatefulWidget {
  final data;
  QrGen({@required this.data});

  @override
  State<QrGen> createState() => _QrGenState(d: data);
}

String qrdata = "Hello";

class _QrGenState extends State<QrGen> {
  var d;
  _QrGenState({@required this.d});
  final qrKey = GlobalKey();

  late PermissionStatus res;
  void takeScreenShot() async {
    res = await Permission.storage.request();
    if (res.isGranted) {
      final boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // We can increse the size of QR using pixel ratio
      final image = await boundary.toImage(pixelRatio: 5.0);
      final byteData = await (image.toByteData(format: ImageByteFormat.png));
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        // getting directory of our phone
        final directory = (await getApplicationDocumentsDirectory()).path;
        final imgFile = File(
          '$directory/${DateTime.now()}${qrdata}.png',
        );
        imgFile.writeAsBytes(pngBytes);
        GallerySaver.saveImage(imgFile.path).then((success) async {
          //In here you can show snackbar or do something in the backend at successfull download
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String qrdata = d.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
        actions: <Widget>[],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RepaintBoundary(
              key: qrKey,
              child: Center(
                child: QrImage(
                  data: qrdata, //This is the part we give data to our QR
                  //  embeddedImage: , You can add your custom image to the center of your QR
                  //  semanticsLabel:'', You can add some info to display when your QR scanned
                  size: 250,
                  backgroundColor: Colors.white,
                  version: QrVersions.auto, //You can also give other versions
                ),
              ),
            ),
            Text(
              "Show this QR to the customer",
              style: TextStyle(fontSize: 20.0),
            ),
            ElevatedButton(
                child: const Text("Download QR code"),
                onPressed: () {
                  takeScreenShot();
                  final snackBar = SnackBar(
                    content: const Text("QR Code added to gallery!"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                })
          ],
        ),
      ),
    );
  }
}
