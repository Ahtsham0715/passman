import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/constants.dart';
import 'package:passman/profile/controller/user_profile_controller.dart';
import 'package:passman/res/components/custom_snackbar.dart';

class changeEmailDialog extends StatefulWidget {
  @override
  _changeEmailDialogState createState() => _changeEmailDialogState();
}

class _changeEmailDialogState extends State<changeEmailDialog> {
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final currentemail = FirebaseAuth.instance.currentUser!.email.toString();
  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(newEmail);
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        "Update Email",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontSize: 22.0,
          fontFamily: 'majalla',
        ),
      ),
      content: Container(
        // width: double.maxFinite,
        // height: MediaQuery.of(context).size.height * 0.33,
        child: Form(
          key: formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // TextFormField(
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   controller: _emailController,
              //   obscureText: false,
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return "Current Email Required";
              //     }
              //     if (value.toString() != currentemail) {
              //       return "Invalid Email";
              //     }
              //     return null;
              //   },
              //   decoration: InputDecoration(
              //     hintText: "Current Email",
              //     prefixIcon: Icon(Icons.email_rounded),
              //   ),
              // ),
              // SizedBox(
              //   height: 15.0,
              // ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password Required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: _newEmailController,
                obscureText: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "New Email Required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "New Email",
                  prefixIcon: Icon(Icons.email_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.red,
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'majalla',
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        GetBuilder<ProfileController>(builder: (controller) {
          return TextButton(
            child: controller.isWorking
                ? CircularProgressIndicator(
                    color: Colors.green.shade800,
                  )
                : Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'majalla',
                    ),
                  ),
            onPressed: () async {
              if (formkey.currentState!.validate()) {
                controller.isWorking = true;
                controller.update();
                try {
                  AuthCredential credential = EmailAuthProvider.credential(
                      email: currentemail, password: _passwordController.text);
                  await firebaseUser!.reauthenticateWithCredential(credential);
                  // await firebaseUser!
                  //     .verifyBeforeUpdateEmail(_newEmailController.text.trim());
                  firebaseUser!
                      .verifyBeforeUpdateEmail(_newEmailController.text.trim())
                      .then(
                    (value) async {
                      // firebaseUser!.sendEmailVerification();
                      // _emailController.clear();
                      _newEmailController.clear();
                      _passwordController.clear();
                      Get.back();

                      styledsnackbar(
                          txt:
                              'We have sent a verification link to your new email.Your email will be updated to the new one after being verified.',
                          icon: Icons.check,
                          sec: 3);
                      logininfo.put('bio_auth', false);
                      FirebaseAuth.instance.signOut();
                      controller.isWorking = false;
                      controller.update();
                      // snackbarKey.currentState?.showSnackBar(customSnackBar(
                      //   txt: AppLocalizations.of(context)!.emailUpdatedSuccessfully,
                      // ));
                      // user.signOut();
                      // Navigator.of(context).pushNamedAndRemoveUntil(
                      //     RoutesName.login, (route) => false);
                    },
                  ).catchError((e) {
                    // Get.back();
                    controller.isWorking = false;
                    controller.update();
                    styledsnackbar(
                        txt: 'Error: ${e.message}', icon: Icons.error_outlined);
                  });
                } on FirebaseAuthException catch (e) {
                  // Get.back();
                  controller.isWorking = false;
                  controller.update();
                  styledsnackbar(
                      txt: 'Error: ${e.message}', icon: Icons.error_outlined);
                }

                // Navigator.of(context).pop(_passwordController.text);
              }
            },
          );
        }),
      ],
    );
  }
}
