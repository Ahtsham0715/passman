import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:passman/constants.dart';

import '../../res/components/custom_snackbar.dart';

class ProfileController extends GetxController {
  bool isedit = false;
  bool isselected = false;
  String path = '';
  String imgurl = logininfo.get('img');
  Future<void> uploadFile(
      {required String filePath, required String userid}) async {
    File file = File(filePath);

    try {
      await FirebaseStorage.instance
          .ref('images/profile_pictures/$userid.png')
          .putFile(file)
          .then((res) async {
        imgurl = await res.ref.getDownloadURL();
      });
    } on FirebaseException catch (e) {
      styledsnackbar(txt: 'Error occured. $e', icon: Icons.error);
      // Get.snackbar('Error occured.', '');
    }
  }

  Future updateData({required String name}) async {
    final db = FirebaseFirestore.instance.collection('users');
    try {
      await db.doc(logininfo.get('userid')).set(
          {
            'name': name,
            'imgUrl': imgurl.toString(),
          },
          SetOptions(
            merge: true,
          ));
      logininfo.put('name', name);
      logininfo.put('img', imgurl.toString());

      // Get.back();
      Get.back();
      isedit = false;
      update();
      styledsnackbar(
          txt: 'Data Updated Successfully', icon: Icons.check_outlined);
    } on FirebaseException catch (e) {
      Get.back();

      styledsnackbar(txt: 'Error occured. $e', icon: Icons.error);

      // Get.snackbar('Error occured.', '');
    }
  }
}
