import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/Auth/controllers/auth_controller.dart';
import 'package:passman/Auth/privacy_policy_screen.dart';
import 'package:passman/Auth/register_page.dart';
import 'package:passman/constants.dart';
import 'package:passman/res/components/custom_formfield.dart';
import 'package:passman/records/records_page.dart';
import 'package:passman/res/components/custom_shape.dart';
import 'package:passman/res/components/onwillpop.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  AuthController controller = Get.put(AuthController());

  bool passwordVisible = true;
  // Visibility of password
  void _passwordVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    // controller.checkBiometrics();
    // controller.update();
  }

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.put(AuthController());

    return WillPopScope(
      onWillPop: () async {
        return onWillPop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        resizeToAvoidBottomInset: false,
        body: GetBuilder<AuthController>(builder: (authcontroller) {
          return Container(
            // padding: const EdgeInsets.only(top: 15.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white.withOpacity(0.9),
            child: //Add this CustomPaint widget to the Widget Tree
                Form(
              key: _formkey,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'Login',
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
                          text: 'By signing in you are agreeing\nour ',
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
                    height: MediaQuery.of(context).size.height * 0.025,
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
                  ),
                  SizedBox(
                    height: responsiveHW(context, ht: 3),
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
                  ),
                  SizedBox(
                    height: responsiveHW(context, ht: 3),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextButton(
                          onPressed: () {
                            Get.to(
                              () => const RegisterPage(),
                            );
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 21.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'majalla',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontSize: 21.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'majalla',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Get.to(
                        () => const PasswordsPage(),
                      );
                    },
                    color: Colors.green,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.055,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'majalla'),
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Expanded(
                    child: Stack(
                      fit: StackFit.passthrough,
                      alignment: AlignmentDirectional.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: Image.asset(
                            'assets/auth.png',
                          ),
                        ),
                        CustomPaint(
                          size: Size(
                              MediaQuery.of(context).size.width,
                              (MediaQuery.of(context).size.width *
                                      0.6352657004830918)
                                  .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                          painter: CustomAuthShape(),
                        ),
                        Positioned(
                          bottom: 50.0,
                          child: !controller.isbiometricavailable.value
                              ? const Center()
                              : MaterialButton(
                                  onPressed: () {
                                    // Get.snackbar('tie', 'msage');
                                    controller.authenticateWithBiometrics();
                                  },
                                  color: Colors.green,
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 2.0,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  minWidth: 5,
                                  padding: const EdgeInsets.all(1.0),
                                  height: MediaQuery.of(context).size.height *
                                      0.095,
                                  child: const Icon(
                                    Icons.fingerprint,
                                    color: Colors.white,
                                    size: 60.0,
                                  ),
                                ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          child: !controller.isbiometricavailable.value
                              ? const Center()
                              : Text(
                                  'Login with touch ID',
                                  style: TextStyle(
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'majalla',
                                    color: Colors.white.withOpacity(0.85),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //     width: MediaQuery.of(context).size.width * 0.8,
                  //     height: MediaQuery.of(context).size.height * 0.1,
                  //     child: Image.asset('assets/auth.png')),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
