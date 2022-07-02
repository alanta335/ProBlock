import 'package:flutter/material.dart';

class CountItem extends StatelessWidget {
  final String count;
  final String text;
  CountItem({Key? key, required this.count, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          color: Color(0xfff0f0f0),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
          ),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
