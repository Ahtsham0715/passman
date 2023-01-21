import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:passman/Auth/controllers/user_data_controller.dart';
import 'package:passman/Auth/fingerprint_page.dart';
import 'package:passman/Auth/verify_email_page.dart';
import 'package:passman/constants.dart';
import 'package:passman/res/components/custom_snackbar.dart';
import '../../records/records_page.dart';
import '../../res/components/loading_page.dart';
import 'package:encrypt/encrypt.dart' as encryption;

class AuthController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  RxBool isbiometricavailable = false.obs;
  RxString path = ''.obs;
  String imgurl = '';

  bool isAuthenticating = false;
  var encrypted;
  var decrypted;

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
          // styledsnackbar(txt: 'Login Successful.', icon: Icons.check_box);
          // Get.to(
          //   () => const PasswordsPage(),
          // );
          Get.dialog(LoadingPage());
          loginuser(
              email: encrypter.decrypt(
                  encryption.Encrypted.from64(logininfo.get('email')),
                  iv: iv),
              password: encrypter.decrypt(
                  encryption.Encrypted.from64(logininfo.get('password')),
                  iv: iv));
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

  Future loginuser({required String email, required String password}) async {
    try {
      UserCredential usercredentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final UserDataController controller = Get.put(UserDataController());
      logininfo.put('userid', usercredentials.user?.uid.toString());
      await controller.getUserData();
      Get.back();
      styledsnackbar(txt: 'Login Successful.', icon: Icons.check_outlined);
      var emailencrypt = encrypter.encrypt(email, iv: iv);
      var passwordencrypt = encrypter.encrypt(password, iv: iv);
      print(emailencrypt.base64);
      print(passwordencrypt.base64);

      logininfo.put(
        'email',
        emailencrypt.base64,
      );
      logininfo.put(
        'password',
        passwordencrypt.base64,
      );
      if (usercredentials.user!.emailVerified) {
        if (logininfo.get('bio_auth') == null && isbiometricavailable.value) {
          Get.to(
            () => const AskBioAuth(),
          );
        } else {
          Get.to(
            () => const PasswordsPage(),
          );
        }
      } else {
        Get.to(
          () => const verifyemail(),
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        styledsnackbar(
            txt: 'No user found for that email.', icon: Icons.error_outlined);
      } else if (e.code == 'wrong-password') {
        styledsnackbar(
            txt: 'Wrong password provided for that user.',
            icon: Icons.error_outlined);
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
      Get.back();

      styledsnackbar(txt: 'Error occured. $e', icon: Icons.error_outlined);
    }
  }

  Future registerUser(
      {required String emailAddress,
      required String name,
      required String imgpath,
      required String password}) async {
    final db = FirebaseFirestore.instance.collection('users');
    try {
      final credentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      try {
        await uploadFile(
            filePath: imgpath, userid: credentials.user!.uid.toString());
        try {
          await db.doc(credentials.user?.uid.toString()).set({
            'name': name,
            'email': emailAddress,
            'imgUrl': imgurl.toString(),
          });

          var emailencrypt = encrypter.encrypt(emailAddress, iv: iv);

          var passwordencrypt = encrypter.encrypt(password, iv: iv);

          print(emailencrypt.base64);
          print(passwordencrypt.base64);
          logininfo.put('userid', credentials.user?.uid.toString());
          logininfo.put('name', name);
          logininfo.put('img', imgurl.toString());
          logininfo.put(
            'email',
            emailencrypt.base64,
          );
          logininfo.put(
            'password',
            passwordencrypt.base64,
          );
          // logininfo.put('credentials', {
          //   'name': nameencrypt.base64,
          //   'email': emailencrypt.base64,
          //   'password': passwordencrypt.base64,
          // });

          await credentials.user?.sendEmailVerification();
          Get.back();
          path.value = '';
          update();
          styledsnackbar(
              txt: 'A verification link has been sent to your email.',
              icon: Icons.check_outlined);
          Get.to(
            () => const verifyemail(),
          );
        } on FirebaseException catch (e) {
          print(e.code);
          print(e.message);
          Get.back();

          styledsnackbar(
              txt: 'Error occured. ${e.message}', icon: Icons.error_outlined);
        }
      } on FirebaseException catch (e) {
        print(e.code);
        print(e.message);
        Get.back();

        styledsnackbar(
            txt: 'Error occured. ${e.message}', icon: Icons.error_outlined);
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        styledsnackbar(
            txt: 'The password provided is too weak.',
            icon: Icons.error_outlined);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        styledsnackbar(
            txt: 'The account already exists for that email.',
            icon: Icons.error_outlined);
      }
    } catch (e) {
      print(e);
      Get.back();

      styledsnackbar(txt: 'Error occured. $e', icon: Icons.error_outlined);
    }
  }
}
