import 'package:flutter/material.dart';

class SignupSwitch extends StatelessWidget {
  bool isManu;
  var onTap;
  SignupSwitch({this.isManu = true, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: (int index) {
        onTap();
      },
      borderColor:Colors.black.withAlpha(100),
      fillColor: Color(0xFF8954E7),
      borderWidth: 1,
      selectedBorderColor: Colors.black.withAlpha(100),
      selectedColor: Colors.white,
      borderRadius: BorderRadius.circular(50),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 100,
            child: Text(
              'Manufacturar',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width:100,
            child: Text(
              'Customer',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
      isSelected: [isManu, !isManu],
    );
  }
}
