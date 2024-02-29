import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:local_auth/local_auth.dart';
import 'package:passman/res/components/custom_snackbar.dart';
import 'package:passman/res/components/loading_page.dart';

import '../../constants.dart';
import '../models/password_model.dart';

class RecordsController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  RxBool isauthenticated = false.obs;
  bool isSearchBarVisible = false;
  List box = [];

  void combinedata() {
    Map<dynamic, PasswordModel> passbox =
        Hive.box<PasswordModel>(logininfo.get('userid')).toMap();
    Map folderbox = Hive.box('folders${logininfo.get('userid')}').toMap();

    box.clear();

    folderbox.forEach((key, value) {
      box.add({
        'key': key.toString(),
        'value': value,
        'title': value['name'].toString(),
        'isfolder': true,
      });
    });
    passbox.forEach((key, value) {
      box.add({
        'key': key.toString(),
        'value': value,
        'title': value.title.toString(),
        'isfolder': false,
      });
    });
  }

  @override
  void onInit() {
    combinedata();
    update();
    super.onInit();
    foldersbox.listenable().addListener(() {
      combinedata();
      update();
    });
    passwordbox.listenable().addListener(() {
      combinedata();
      update();
    });
  }

  Future importPasswordsFromCloud() async {
    Get.dialog(LoadingPage());
    Map cloudData = {};
    Map<String, PasswordModel> modelData = {};
    bool hasFolderData = false;
    firestore
        .collection('backups')
        .doc(uid)
        // .collection('myBackups')
        .get()
        .then((DocumentSnapshot doc) {
      // for (var doc in data.docs) {
      try {
        if (doc.exists) {
          cloudData = doc.data() as Map;
          cloudData.forEach((key, value) async {
            if (value['folderKey'].toString().isNotEmpty) {
              if (!foldersbox.containsKey(value['folderKey'])) {
                foldersbox.put(value['folderKey'], {
                  'name': value['folderName'],
                  'type': 'Passwords',
                });
                hasFolderData = true;
              }
              Box<PasswordModel> fpBox =
                  Hive.isBoxOpen('${value['folderKey']};$uid')
                      ? Hive.box('${value['folderKey']};$uid')
                      : await Hive.openBox('${value['folderKey']};$uid');
              print('${value['folderKey']};$uid');
              // if (!fpBox.containsKey(key)) {
              fpBox.put(
                  key, PasswordModel.fromJson(value as Map<String, dynamic>));
              // }
            } else {
              if (!passwordbox.containsKey(key)) {
                modelData[key] =
                    PasswordModel.fromJson(value as Map<String, dynamic>);
              }
            }
          });
          Get.back();
          if (modelData.isNotEmpty) {
            passwordbox.putAll(modelData);
            styledsnackbar(
                txt: 'Backup Imported Successfully', icon: Icons.check_box);
          } else {
            if (hasFolderData) {
              styledsnackbar(
                  txt: 'Backup Imported Successfully', icon: Icons.check_box);
            } else {
              styledsnackbar(
                  txt: 'All Passwords already available locally',
                  icon: Icons.warning);
            }
          }
        } else {
          Get.back();
          styledsnackbar(txt: 'No Backup Found', icon: Icons.error);
        }
      } catch (e) {
        print('restore backup error: $e');
      }
      // }
    }).catchError((e) {
      Get.back();
      print(e);
      styledsnackbar(txt: 'Error Occured.Try Again', icon: Icons.error);
    });
// passwordbox.putAll(entries);
  }

  Future backupPasswordsToCloud() async {
    Get.dialog(LoadingPage());
    Map<dynamic, PasswordModel> passwordBoxMap = passwordbox.toMap();
    Map<String, Map> passwordBoxModified = {};
    // print(passwordBoxMap);
    print(passwordBoxMap.length);
    List allFolderPasswordBoxesKey = [];
    if (!Hive.isBoxOpen('passwordFolderBoxes${logininfo.get('userid')}')) {
      await Hive.openBox('passwordFolderBoxes${logininfo.get('userid')}');
      allFolderPasswordBoxesKey = allPasswordFolderBoxes.values.toList();
    } else {
      allFolderPasswordBoxesKey = allPasswordFolderBoxes.values.toList();
    }

    print(allPasswordFolderBoxes.toMap());
    passwordBoxMap.forEach((key, value) {
      passwordBoxModified[key.toString()] = value.toJson();
    });
    allFolderPasswordBoxesKey.forEach((key) async {
      if (!Hive.isBoxOpen(key)) {
        await Hive.openBox<PasswordModel>(key);
      }
      if (Hive.box<PasswordModel>(key).isNotEmpty) {
        print(Hive.box<PasswordModel>(key).toMap());
        Map<dynamic, PasswordModel> thisBoxMap =
            Hive.box<PasswordModel>(key).toMap();
        thisBoxMap.forEach((key2, value) {
          passwordBoxModified[key2.toString()] = value.toJson();
        });
      }
    });
    // Get.back(); //todo
    // print(passwordBoxModified);
    print(passwordBoxModified.length);
    print(passwordBoxModified);
    firestore
        .collection('backups')
        .doc(uid)
        // .collection('myBackups')
        // .doc(timestamp.toString())
        .set(
            passwordBoxModified,
            SetOptions(
              merge: false,
            ))
        .then((value) {
      Get.back();
      styledsnackbar(
          txt: 'Backup Uploaded Successfully', icon: Icons.check_box);
    }).catchError((e) {
      Get.back();
      print(e);
      styledsnackbar(txt: 'Error Occured.Try Again', icon: Icons.error);
    });
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      await auth
          .authenticate(
        localizedReason: ' ',
        options: const AuthenticationOptions(
          stickyAuth: true,
          sensitiveTransaction: true,
          // useErrorDialogs: false,
          // biometricOnly: true,
        ),
      )
          .then((authenticated) {
        if (authenticated) {
          // return true;
          isauthenticated.value = true;
        } else {
          // return false;
          isauthenticated.value = false;
        }
      });
    } on PlatformException catch (e) {
      print(e);
      styledsnackbar(
          txt: '${e.message}\n Disable fingerprint auth and use password.',
          icon: Icons.error_outline);
      isauthenticated.value = false;
      return;
    }
  }
}
