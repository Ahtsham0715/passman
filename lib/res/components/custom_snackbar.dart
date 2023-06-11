import 'package:flutter/material.dart';
import 'package:get/get.dart';

void styledsnackbar({required txt, icon = Icons.wifi_sharp, int sec = 2}) {
  Get.rawSnackbar(
    margin: const EdgeInsets.all(15.0),
    messageText: Text(
      txt,
      style: const TextStyle(
          color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w400),
    ),
    isDismissible: false,
    backgroundColor: Colors.black38.withOpacity(0.5),
    borderRadius: 20.0,
    //  borderWidth: 15.0,
    icon: Icon(
      icon,
      color: Colors.white,
      size: 25.0,
    ),
    duration: Duration(seconds: sec),
  );
}
