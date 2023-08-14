import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/Auth/fingerprint_page.dart';
import 'package:passman/constants.dart';
import 'package:passman/records/records_page.dart';
import 'package:passman/res/components/custom_snackbar.dart';

class verifyemail extends StatefulWidget {
  const verifyemail({Key? key}) : super(key: key);

  @override
  _verifyemailState createState() => _verifyemailState();
}

class _verifyemailState extends State<verifyemail> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;

  @override
  void initState() {
    user = auth.currentUser;
    user?.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user?.reload();
    if (user!.emailVerified) {
      timer?.cancel();
      if (logininfo.get('bio_auth') == null) {
        Get.to(
          () => const AskBioAuth(),
        );
      } else {
        Get.to(
          () => const PasswordsPage(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // backgroundColor: Colors.teal,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Verify Your email',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0XFFd66d75),
                  Color(0XFFe29587),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.topSlide,
                  dialogType: DialogType.question,
                  // body: Center(child: Text(
                  //         'If the body is specified, then title and description will be ignored, this allows to 											further customize the dialogue.',
                  //         style: TextStyle(fontStyle: FontStyle.italic),
                  //       ),),
                  title: 'Are you sure?',
                  desc: 'Do you want to logout?',
                  btnOkOnPress: () async {
                    try {
                      // Get.back();
                      await FirebaseAuth.instance.signOut();
                      styledsnackbar(
                          txt: 'user logged out.', icon: Icons.logout_outlined);
                    } catch (e) {
                      //  Get.back();

                      styledsnackbar(
                          txt: 'Error Occured. $e', icon: Icons.error);
                    }
                  },
                  btnCancelOnPress: () {
                    // Get.back();
                  },
                )..show();
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
              ),
              child: Center(
                child: Text(
                  'A verification link has been sent to your email. please verify your email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.currentUser
                    ?.sendEmailVerification()
                    .then((value) {
                  styledsnackbar(
                      txt: 'verification link has been sent.',
                      icon: Icons.check_outlined);
                });
              },
              // color: Colors.teal,
              // minWidth: MediaQuery.of(context).size.width * 0.9,
              // height: MediaQuery.of(context).size.height * 0.05,
              // shape: StadiumBorder(),
              child: Text(
                'Resend Link',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.blue,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
