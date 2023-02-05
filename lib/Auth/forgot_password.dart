import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/res/components/custom_formfield.dart';
import 'package:passman/res/components/custom_snackbar.dart';
import 'package:passman/res/components/loading_page.dart';

import '../constants.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            height: responsiveHW(context, ht: 9),
            width: responsiveHW(context, wd: 100),
            alignment: Alignment.center,
            // decoration: const BoxDecoration(
            //   borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            //   color: Colors.teal,
            // ),
            child: const Text(
              "Forgot Your Password?",
              style: TextStyle(
                  color: Color(0XFFd66d75),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: [
              Container(
                height: responsiveHW(context, ht: 8),
                width: responsiveHW(context, wd: 80),
                alignment: Alignment.center,
                child: const Text(
                  "Enter the Email address associated with your account",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: responsiveHW(context, ht: 2),
              ),
              customTextField(
                "Email",
                false,
                null,
                _email,
                (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Your Email";
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return "Please Enter Valid Email Address";
                  }
                },
                (value) {
                  _email.text = value!;
                },
                responsiveHW(context, wd: 100),
                responsiveHW(context, ht: 100),
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(95.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                pIcon: Icons.email_outlined,
                piconcolor: Colors.grey,
                textcolor: Colors.grey,
              ),
              SizedBox(
                height: responsiveHW(context, ht: 3),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsiveHW(context, wd: 5)!.toDouble(),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(95)),
                      color: Color(0XFFd66d75)),
                  height: responsiveHW(context, ht: 6),
                  width: responsiveHW(context, wd: 200),
                  child: TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Get.back();
                        Get.dialog(LoadingPage());
                        final methods = await FirebaseAuth.instance
                            .fetchSignInMethodsForEmail(_email.text.trim());
                        if (methods.isNotEmpty) {
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: _email.text.trim());
                            logininfo.put('bio_auth', false);
                            Get.back();

                            styledsnackbar(
                                txt: 'Password reset link sent successfully',
                                icon: Icons.check);
                          } catch (e) {
                            // Navigator.pop(context);
                            Get.back();

                            styledsnackbar(
                                txt: 'Error Occured. $e',
                                icon: Icons.error_outline);
                          }
                        } else {
                          // Navigator.pop(context);
                          Get.back();
                          styledsnackbar(
                              txt: 'email not registered',
                              icon: Icons.error_outline);
                        }
                      }
                    },
                    child: Text("Reset Password",
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              SizedBox(
                height: responsiveHW(context, ht: 3),
              ),
              Container(
                height: responsiveHW(context, ht: 30),
                width: responsiveHW(context, ht: 30),
                color: Colors.transparent,
                child: Image.asset(
                  "assets/forgetPassword.png",
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: responsiveHW(context, ht: 3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
