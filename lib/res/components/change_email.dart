import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class changeEmailDialog extends StatefulWidget {
  @override
  _changeEmailDialogState createState() => _changeEmailDialogState();
}

class _changeEmailDialogState extends State<changeEmailDialog> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final currentemail = FirebaseAuth.instance.currentUser!.email.toString();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        "Update Email",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontSize: 22.0,
          fontFamily: 'majalla',
        ),
      ),
      content: Container(
        width: double.maxFinite,
        // height: MediaQuery.of(context).size.height * 0.33,
        child: Form(
          key: formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                controller: _emailController,
                obscureText: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Current Email Required";
                  }
                  if (value.toString() != currentemail) {
                    return "Invalid Email";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Current Email",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password Required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: _newEmailController,
                obscureText: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "New Email Required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "New Email",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.red,
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'majalla',
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        TextButton(
          child: Text(
            "Submit",
            style: TextStyle(
              color: Colors.green.shade800,
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'majalla',
            ),
          ),
          onPressed: () {
            if (formkey.currentState!.validate()) {
              Navigator.of(context).pop(_passwordController.text);
            }
          },
        ),
      ],
    );
  }
}
