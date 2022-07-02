import 'package:flutter/material.dart';

class SignupFormCust extends StatelessWidget {
  final nameController;
  final locController;
  final emailController;
  final pnoController;
  final addressController;
  final dobController;
  SignupFormCust(
      {this.nameController,
      this.locController,
      this.emailController,
      Key? key,
      this.pnoController, this.addressController, this.dobController})
      : super(key: key);

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
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Email',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: pnoController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Phone',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: locController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Location',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: addressController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Address',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: dobController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Date of Birth',
            ),
          ),
        ],
      ),
    );
  }
}
