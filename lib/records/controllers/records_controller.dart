import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:local_auth/local_auth.dart';

class RecordsController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  RxBool isauthenticated = false.obs;
  Future<void> authenticateWithBiometrics() async {
    try {
      await auth
          .authenticate(
        localizedReason: ' ',
        options: const AuthenticationOptions(
          stickyAuth: true,
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
      isauthenticated.value = false;
      return;
    }
  }
}
