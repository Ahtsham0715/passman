import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> onWillPop(ctx) async {
  return (await showDialog(
        context: ctx,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Are you sure?'),
          content: const Text('Do you want to exit the App'),
          actions: <Widget>[
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            MaterialButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text('Yes'),
            ),
          ],
        ),
      )) ??
      false;
}
