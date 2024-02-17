import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:passman/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../res/components/custom_snackbar.dart';
import '../../res/components/loading_page.dart';
import 'package:encrypt/encrypt.dart' as encryption;
import 'dart:developer' as dev;

class MediaController extends GetxController {
  int selectedRadio = 0;
  List pickedfiles = [];

  List<String> videoExtensions = [
    "mp4",
    "mkv",
    "avi",
    "mov",
    "wmv",
    "flv",
    "webm",
    // ... (add more extensions as needed)
  ];

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

  IconData fileIconDecider(String extension) {
    if (extension.toLowerCase() == 'pdf') {
      return FontAwesomeIcons.filePdf;
    } else if (extension.toLowerCase().contains('doc')) {
      return FontAwesomeIcons.fileWord;
    } else if (extension.toLowerCase().contains('xl')) {
      return FontAwesomeIcons.fileExcel;
    } else if (videoExtensions.contains(extension.toLowerCase())) {
      return FontAwesomeIcons.fileVideo;
    } else if (extension.toLowerCase().contains('txt')) {
      return FontAwesomeIcons.fileLines;
    } else {
      return FontAwesomeIcons.file;
    }
  }

  Future<void> deleteFile(String filePath) async {
    final status = await Permission.manageExternalStorage.status;
    try {
      if (status.isGranted) {
        File(filePath).delete(recursive: true);
      } else {
        await Permission.manageExternalStorage.request();
        File(filePath).delete(recursive: true);
      }
    } catch (e) {
      print('file deletion error: $e');
    }
  }

  Uint8List decryptFile(file) {
    var decryptedFile =
        encrypter.decryptBytes(encryption.Encrypted(file), iv: iv);
    // final bytes = Uint8List.fromList(decryptedFile.codeUnits);
    // print(bytes); // Convert to bytes directly
    return Uint8List.fromList(decryptedFile);
  }

  Future uploadFileToVault({
    required String folderKey,
    required List<AssetEntity> selectedFiles,
  }) async {
    Get.dialog(LoadingPage());
    try {
      for (var file in selectedFiles) {
        var entityFile = await file.file;
        var entityFileBytes = await entityFile!.readAsBytes();
        var encryptedEntityFile =
            await encrypter.encryptBytes(entityFileBytes, iv: iv);
        print('encrypted image: $encryptedEntityFile');

        pickedfiles.add({
          'size': await entityFile.length(),
          'type': file.title!.split('.')[1].toLowerCase(),
          'data': encryptedEntityFile.bytes,
          'name': file.title,
          'absolutePath': entityFile.absolute.path
        });
        print(pickedfiles);
        await foldersdatabox.put(folderKey, pickedfiles);
        deleteFile(entityFile.absolute.path);
      }
      Get.back();
    } catch (e) {
      print(e);
      Get.back();
      styledsnackbar(txt: 'Error occured> $e', icon: Icons.error);
    }
  }

  Future<void> uploadFiles(
      {required FilePickerResult result, required String folderKey}) async {
    Get.dialog(LoadingPage());

    try {
      if (foldersdatabox.containsKey(folderKey)) {
        pickedfiles = foldersdatabox.get(folderKey);
      } else {
        pickedfiles = [];
      }
      Directory appDocDir = await getApplicationDocumentsDirectory();
      print(appDocDir.path);

      result.files.forEach((file) async {
        print(file.name);
        print(file.extension);
        // File(file.path!).copy('${appDocDir.path}/${file.name}');
        pickedfiles.add({
          'size': file.size,
          'type': file.extension,
          'data': '${appDocDir.path}/${file.name}'.toString(),
          'name': file.name,
        });
        deleteFile(file.path!);
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
