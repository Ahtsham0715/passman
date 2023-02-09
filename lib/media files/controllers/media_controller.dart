import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

import 'package:passman/constants.dart';

import '../../res/components/custom_snackbar.dart';

class MediaController extends GetxController {
  int selectedRadio = 0;
  List pickedfiles = [];
  @override
  void onInit() {
    super.onInit();
    foldersdatabox.listenable().addListener(() {
      update([
        'folder_view_builder',
      ]);
    });
    // passwordbox.listenable();
  }

  String generateHiveKey() {
    var rng = new Random.secure();
    var values = new List<int>.generate(20, (_) => rng.nextInt(256));
    return base64Url.encode(values);
  }

  Future<Uint8List> readFileAsBytes(String filePath) async {
    File file = File(filePath);
    Uint8List bytes = await file.readAsBytes();
    return bytes;
  }

  Future<String> encodeImageToBase64(Uint8List image) async {
    return base64Encode(image);
  }

  Uint8List decodeImageFromBase64(String base64String) {
    return base64Decode(base64String);
  }

  Future<void> createFolder(
      {required String folderName, required String folderType}) async {
    String randomKey = generateHiveKey();
    print(folderName);
    print(randomKey);
    if (foldersbox.containsKey(randomKey)) {
      randomKey = generateHiveKey();
    } else {}
    try {
      foldersbox.put(randomKey, {
        'name': folderName.toString(),
        'type': folderType.toString(),
      });

      Get.back();

      // print(foldersbox.keys.toList());
      // print(foldersbox.values.toList());
      // styledsnackbar(txt: 'Folder Created Successfully.', icon: Icons.check);
    } catch (e) {
      Get.back();
      styledsnackbar(
          txt: 'Error ocurred  while creating new folder. ${e}',
          icon: Icons.error_outline);
    }
  }
}
