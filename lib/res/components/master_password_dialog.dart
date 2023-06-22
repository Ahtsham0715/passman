import 'package:flutter/material.dart';

class MasterPasswordDialog extends StatefulWidget {
  @override
  _MasterPasswordDialogState createState() => _MasterPasswordDialogState();
}

class _MasterPasswordDialogState extends State<MasterPasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        "Enter Master Password",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontSize: 22.0,
          fontFamily: 'majalla',
        ),
      ),
      content: Container(
        // width: double.maxFinite,
        child: Form(
          key: formkey,
          child: TextFormField(
            controller: _passwordController,
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return "Master Password Required";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Icon(Icons.lock),
            ),
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
