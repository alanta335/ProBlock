import 'package:flutter/material.dart';

class SignupFormMan extends StatelessWidget {
  final nameController ;
  final locController;
  final emailController;
  final pnoController;
  SignupFormMan({Key? key, this.nameController, this.locController, this.emailController, this.pnoController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Name',
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Email',
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: pnoController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Phone',
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: locController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Location',
            ),
          ),
        ],
      ),
    );
  }
}
