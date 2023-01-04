import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:passman/res/components/custom_snackbar.dart';

import '../../records/records_page.dart';

class AuthController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  RxBool isbiometricavailable = false.obs;

  bool isAuthenticating = false;

  @override
  void onInit() {
    super.onInit();
    checkBiometrics();
  }

  Future<void> checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      if (kDebugMode) {
        print(canCheckBiometrics);
      }
      isbiometricavailable.value = canCheckBiometrics;
      update();
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      isbiometricavailable.value = canCheckBiometrics;
      update();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      await auth
          .authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          // biometricOnly: true,
        ),
      )
          .then((authenticated) {
        if (authenticated) {
          styledsnackbar(txt: 'Login Successful.', icon: Icons.check_box);
          Get.to(
            () => const PasswordsPage(),
          );
        } else {
          styledsnackbar(txt: 'Unable to authenticate', icon: Icons.error);
        }
      });
    } on PlatformException catch (e) {
      styledsnackbar(txt: 'Error occured. $e', icon: Icons.error);
      if (kDebugMode) {
        print(e);
      }

      return;
    }
  }

//   Future<void> cancelAuthentication() async {
//     await auth.stopAuthentication();
//     // setState(() => _isAuthenticating = false);
//   }
}
