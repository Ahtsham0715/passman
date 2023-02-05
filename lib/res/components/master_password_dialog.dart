import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encryption;
import 'package:passman/res/components/custom_snackbar.dart';
import '../../constants.dart';

class MasterPasswordDialog extends StatefulWidget {
  @override
  _MasterPasswordDialogState createState() => _MasterPasswordDialogState();
}

class _MasterPasswordDialogState extends State<MasterPasswordDialog> {
  TextEditingController _passwordController = TextEditingController();

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
        width: double.maxFinite,
        child: TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Password",
            prefixIcon: Icon(Icons.lock),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.black,
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
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'majalla',
            ),
          ),
          onPressed: () {
            print(_passwordController.text);
            Navigator.of(context).pop(_passwordController.text);
          },
        ),
      ],
    );
  }
}
