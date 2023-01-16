import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/res/components/custom_snackbar.dart';

Future<bool> logout(ctx) async {
  return (await showDialog(
        context: ctx,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Are you sure?',
            style: TextStyle(fontSize: 25.0),
          ),
          content: const Text(
            'Do you want to logout.',
            style: TextStyle(fontSize: 25.0),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'No',
                style: TextStyle(fontSize: 25.0),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                Get.back();
                await FirebaseAuth.instance.signOut();
                styledsnackbar(
                    txt: 'user logged out.', icon: Icons.logout_outlined);
              },
              child: const Text(
                'Yes',
                style: TextStyle(fontSize: 25.0),
              ),
            ),
          ],
        ),
      )) ??
      false;
}
