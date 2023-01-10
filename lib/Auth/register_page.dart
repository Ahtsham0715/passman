import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:passman/Auth/controllers/auth_controller.dart';
import 'package:passman/Auth/privacy_policy_screen.dart';
import 'package:passman/constants.dart';
import 'package:passman/res/components/custom_formfield.dart';
import 'package:passman/res/components/custom_shape.dart';
import 'package:passman/res/components/loading_page.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authcontroller = Get.put(AuthController());
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0.0,
        toolbarHeight: 30.0,
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'majalla',
                    ),
                  ),
                ),
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
                          color: Colors.green,
                          fontFamily: 'majalla',
                          fontWeight: FontWeight.w500,
                        )),
                  ]),
                ),
                SizedBox(
                  height: 5,
                ),
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
                  responsiveHW(context, ht: 100),
                  const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  pIcon: Icons.person_outline,
                  piconcolor: Colors.grey,
                  textcolor: Colors.grey,
                ),
                SizedBox(
                  height: responsiveHW(context, ht: 1),
                ),
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
                  responsiveHW(context, ht: 100),
                  const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  pIcon: Icons.email_outlined,
                  piconcolor: Colors.grey,
                  textcolor: Colors.grey,
                ),
                SizedBox(
                  height: responsiveHW(context, ht: 1),
                ),
                customTextField(
                  "Password",
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
                  responsiveHW(context, ht: 100),
                  const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  pIcon: Icons.lock_outline_rounded,
                  piconcolor: Colors.grey,
                  textcolor: Colors.grey,
                ),
                SizedBox(
                  height: responsiveHW(context, ht: 1),
                ),
                customTextField(
                  "Confirm Password",
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
                  responsiveHW(context, ht: 100),
                  const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  pIcon: Icons.lock_outline_rounded,
                  piconcolor: Colors.grey,
                  textcolor: Colors.grey,
                ),
                SizedBox(
                  height: responsiveHW(context, ht: 7),
                ),
                GetBuilder<AuthController>(builder: (cont) {
                  return MaterialButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        Get.dialog(LoadingPage());
                        authcontroller.registerUser(
                            name: _name.text.trim(),
                            emailAddress: _email.text.trim(),
                            password: _password.text);
                      }
                    },
                    color: Colors.green,
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
                  child: Stack(
                    fit: StackFit.passthrough,
                    alignment: AlignmentDirectional.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: Image.asset('assets/auth.png')),
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
