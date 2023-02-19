import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

import 'package:passman/constants.dart';
import 'package:path_provider/path_provider.dart';

import '../../res/components/custom_snackbar.dart';
import '../../res/components/loading_page.dart';

class MediaController extends GetxController {
  int selectedRadio = 0;
  List pickedfiles = [];
  @override
  void onInit() {
    super.onInit();

    foldersdatabox.listenable().addListener(() {
      update();
      print('updated data');
    });
    // passwordbox.listenable();
  }

  String generateHiveKey() {
    var rng = new Random.secure();
    var values = new List<int>.generate(20, (_) => rng.nextInt(256));
    return base64Url.encode(values);
  }

  Future<File> uint8ListToFile(Uint8List data, String filename) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath/$filename');
    await file.writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return file;
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

  Future<void> uploadFiles(
      {required FilePickerResult result, required String folderKey}) async {
    Get.dialog(LoadingPage());

    if (foldersdatabox.containsKey(folderKey)) {
      pickedfiles = foldersdatabox.get(folderKey);
    } else {
      pickedfiles = [];
    }
    Directory appDocDir = await getApplicationDocumentsDirectory();
    print(appDocDir.path);
    result.files.forEach((file) async {
      print(file.name);
      File(file.path!).copy('${appDocDir.path}/${file.name}');
      pickedfiles.add({
        'type': file.extension,
        'data': '${appDocDir.path}/${file.name}'.toString(),
        'name': file.name,
      });
      // readFileAsBytes(file.path!).then((val) async {
      //   // print(value);
      //   encodeImageToBase64(val).then((value) {
      //     pickedfiles.add({
      //       'type': file.extension,
      //       'data': value.toString(),
      //       'name': file.name,
      //     });
      //     // print(value);
      //   });
      // });
    });
    try {
      await foldersdatabox.put(folderKey, pickedfiles);
      // print('updated');

      Get.back();

      // update();
    } catch (e) {
      Get.back();
      styledsnackbar(txt: 'Error occured> $e', icon: Icons.error);
    }
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
