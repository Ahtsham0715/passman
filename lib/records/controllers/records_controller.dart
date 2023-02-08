import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:local_auth/local_auth.dart';
import 'package:passman/res/components/custom_snackbar.dart';

import '../../constants.dart';
import '../models/password_model.dart';

class RecordsController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  RxBool isauthenticated = false.obs;
  bool isSearchBarVisible = false;
  List<PasswordModel> box =
      Hive.box<PasswordModel>(logininfo.get('userid')).values.toList();
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
