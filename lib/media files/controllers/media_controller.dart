import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:passman/constants.dart';

import '../../res/components/custom_snackbar.dart';

class MediaController extends GetxController {
  String generateHiveKey() {
    var rng = new Random.secure();
    var values = new List<int>.generate(20, (_) => rng.nextInt(256));
    return base64Url.encode(values);
  }

  Future<String> encodeImageToBase64(Uint8List image) async {
    return base64Encode(image);
  }

  Future<Uint8List> decodeImageFromBase64(String base64String) async {
    return base64Decode(base64String);
  }

  Future<void> createFolder({required String folderName}) async {
    String randomKey = generateHiveKey();
    print(folderName);
    print(randomKey);
    if (foldersbox.containsKey(randomKey)) {
    } else {
      randomKey = generateHiveKey();
    }
    try {
      foldersbox.put(randomKey, folderName.toString());
      Get.back();
      print(foldersbox.keys.toList());
      print(foldersbox.values.toList());
      // styledsnackbar(txt: 'Folder Created Successfully.', icon: Icons.check);
    } catch (e) {
      Get.back();
      styledsnackbar(
          txt: 'Error ocurred  while creating new folder. ${e}',
          icon: Icons.error_outline);
    }
  }
}
