import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:passman/Auth/controllers/auth_controller.dart';
import 'package:passman/Auth/privacy_policy_screen.dart';
import 'package:passman/constants.dart';
import 'package:passman/res/components/custom_formfield.dart';
import 'package:passman/res/components/custom_shape.dart';
import 'package:passman/res/components/custom_snackbar.dart';
import 'package:passman/res/components/loading_page.dart';

import '../res/components/file_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;

  final FocusNode _namefocusNode = FocusNode();
  final FocusNode _emailfocusNode = FocusNode();
  final FocusNode _passwordfocusNode = FocusNode();
  final FocusNode _confirmpasswordfocusNode = FocusNode();

  // Visibility of password
  void _passwordVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  void _confirmPasswordVisibility() {
    setState(() {
      confirmPasswordVisible = !confirmPasswordVisible;
    });
  }

  @override
  void initState() {
    // FocusScope.of(context).requestFocus(_namefocusNode);
    super.initState();
  }

  @override
  void dispose() {
    _emailfocusNode.dispose();
    _namefocusNode.dispose();
    _passwordfocusNode.dispose();
    _confirmpasswordfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authcontroller = Get.put(AuthController());
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1.0),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white.withOpacity(1.0),
        elevation: 0.0,
        toolbarHeight: 40.0,
        centerTitle: true,
        title: Text(
          'Register',
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'majalla',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // padding: const EdgeInsets.only(top: 15.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white.withOpacity(0.9),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.06,
                // ),
                // const Padding(
                //   padding: EdgeInsets.symmetric(vertical: 2.0),
                //   child:
                // ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    const TextSpan(
                        text: 'By signing up you are agreeing\nour ',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                          fontFamily: 'majalla',
                          fontWeight: FontWeight.w500,
                        )),
                    TextSpan(
                        text: 'Term and privacy policy',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(
                              () => TermsAndPrivacyPolicyPage(),
                            );
                            // print('object');
                          },
                        style: const TextStyle(
                          fontSize: 22.0,
                          color: Color(0XFFd66d75),
                          fontFamily: 'majalla',
                          fontWeight: FontWeight.w500,
                        )),
                  ]),
                ),
                SizedBox(
                  height: 5,
                ),
                Obx(
                  () => Center(
                    child: GestureDetector(
                        onTap: () {
                          filepicker().then((selectedpath) {
                            if (selectedpath.toString().isNotEmpty) {
                              authcontroller.path.value = selectedpath;
                            }
                          });
                        },
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Color(0XFFe29587),
                          foregroundImage:
                              FileImage(File(authcontroller.path.value)),
                          child: Icon(
                            Icons.person,
                            size: 60.0,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
                // SizedBox(
                //   height: 5,
                // ),
                customTextField(
                  "Name",
                  false,
                  null,
                  _name,
                  (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Your Name";
                    }
                    // if (!RegExp(
                    //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    //     .hasMatch(value)) {
                    //   return "Please Enter Valid Email Address";
                    // }
                  },
                  (value) {
                    _name.text = value!;
                  },
                  responsiveHW(context, wd: 100),
                  responsiveHW(context, ht: 70),
                  const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  pIcon: Icons.person_outline,
                  piconcolor: Colors.grey,
                  textcolor: Colors.grey,
                  autofocus: true,
                  focusnode: _namefocusNode,
                  onsubmit: (val) {
                    _namefocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_emailfocusNode);
                  },
                ),
                // SizedBox(
                //   height: responsiveHW(context, ht: 1),
                // ),
                customTextField(
                  "Email Address",
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
                  responsiveHW(context, ht: 70),
                  const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  pIcon: Icons.email_outlined,
                  piconcolor: Colors.grey,
                  textcolor: Colors.grey,
                  focusnode: _emailfocusNode,
                  onsubmit: (val) {
                    _emailfocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_passwordfocusNode);
                  },
                ),
                // SizedBox(
                //   height: responsiveHW(context, ht: 1),
                // ),
                customTextField(
                  "Master Password",
                  passwordVisible,
                  IconButton(
                    // splashColor: Colors.transparent,
                    icon: Icon(
                      //choose the icon on based of passwordVisibility
                      passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: _passwordVisibility,
                  ),
                  _password,
                  (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Your Password";
                    }
                    if (value.toString().length < 8) {
                      return "Password should be 8 digits or more";
                    }
                  },
                  (value) {
                    _password.text = value!;
                  },
                  responsiveHW(context, wd: 100),
                  responsiveHW(context, ht: 70),
                  const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  pIcon: Icons.lock_outline_rounded,
                  piconcolor: Colors.grey,
                  textcolor: Colors.grey,
                  focusnode: _passwordfocusNode,
                  onsubmit: (val) {
                    _passwordfocusNode.unfocus();
                    FocusScope.of(context)
                        .requestFocus(_confirmpasswordfocusNode);
                  },
                ),
                // SizedBox(
                //   height: responsiveHW(context, ht: 1),
                // ),
                customTextField(
                  "Confirm Master Password",
                  confirmPasswordVisible,
                  IconButton(
                    icon: Icon(
                      //choose the icon on based of passwordVisibility
                      confirmPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: _confirmPasswordVisibility,
                  ),
                  _confirmpassword,
                  (value) {
                    if (value!.isEmpty) {
                      return "Please Re-Enter Your Password";
                    }
                    // if (value.toString().length < 8) {
                    //   return "Password should be 8 digits or more";
                    // }
                    if (value != _password.text) {
                      return "Both Password Should Be Matched";
                    }
                  },
                  (value) {
                    _confirmpassword.text = value!;
                  },
                  responsiveHW(context, wd: 100),
                  responsiveHW(context, ht: 70),
                  const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  pIcon: Icons.lock_outline_rounded,
                  piconcolor: Colors.grey,
                  textcolor: Colors.grey,
                  focusnode: _confirmpasswordfocusNode,
                  onsubmit: (val) {
                    _confirmpasswordfocusNode.unfocus();
                    if (_formkey.currentState!.validate()) {
                      if (authcontroller.path.isEmpty) {
                        styledsnackbar(
                            txt: 'Please select profile picture',
                            icon: Icons.error);
                      } else {
                        Get.dialog(LoadingPage());
                        authcontroller.registerUser(
                            name: _name.text.trim(),
                            imgpath: authcontroller.path.value,
                            emailAddress: _email.text.trim(),
                            password: _password.text);
                      }
                    }
                  },
                ),
                SizedBox(
                  height: responsiveHW(context, ht: 4),
                ),
                GetBuilder<AuthController>(builder: (cont) {
                  return MaterialButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        if (authcontroller.path.isEmpty) {
                          styledsnackbar(
                              txt: 'Please select profile picture',
                              icon: Icons.error);
                        } else {
                          Get.dialog(LoadingPage());
                          authcontroller.registerUser(
                              name: _name.text.trim(),
                              imgpath: authcontroller.path.value,
                              emailAddress: _email.text.trim(),
                              password: _password.text);
                        }
                      }
                    },
                    color: Color(0XFFd66d75),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.055,
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'majalla'),
                    ),
                  );
                }),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.05,
                // ),
                Expanded(
                  // flex: 1,
                  child: Stack(
                    fit: StackFit.passthrough,
                    alignment: AlignmentDirectional.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: Image.asset('assets/auth1.jpg')),
                      CustomPaint(
                        size: Size(
                            MediaQuery.of(context).size.width,
                            (MediaQuery.of(context).size.width *
                                    0.6352657004830918)
                                .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                        painter: CustomAuthShape(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
