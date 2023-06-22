import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:passman/constants.dart';
import 'package:passman/profile/controller/user_profile_controller.dart';
import 'package:passman/res/components/change_email.dart';
import 'package:passman/res/components/custom_formfield.dart';
import 'package:passman/res/components/loading_page.dart';
import 'package:encrypt/encrypt.dart' as encryption;
import 'package:passman/res/extensions.dart';
import '../res/components/custom_snackbar.dart';
import '../res/components/file_picker.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    super.key,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final namefocusnode = FocusNode();
  final emailfocusnode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    name.text = logininfo.get('name') ?? '';
    email.text = encrypter
        .decrypt(encryption.Encrypted.from64(logininfo.get('email')), iv: iv);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profilecontroller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        // backgroundColor: Colors.green,
        elevation: 0.0,
        leading: GetBuilder<ProfileController>(builder: (controller) {
          return InkWell(
            onTap: controller.isedit
                ? () {
                    controller.isedit = false;
                    controller.update();
                  }
                : () {
                    Get.back();
                  },
            child: Icon(
              controller.isedit ? Icons.close : Icons.arrow_back,
            ),
          );
        }),
        centerTitle: true,
        title: GetBuilder<ProfileController>(builder: (controller) {
          return Text(
            controller.isedit ? 'Edit Profile' : 'My Profile',
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'majalla'),
          );
        }),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0XFFd66d75),
                Color(0XFFe29587),
              ],
              begin: MediaQuery.of(context).orientation == Orientation.portrait
                  ? Alignment.bottomCenter
                  : Alignment.bottomLeft,
              end: MediaQuery.of(context).orientation == Orientation.portrait
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          GetBuilder<ProfileController>(builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: controller.isedit
                    ? () async {
                        Get.dialog(LoadingPage());
                        try {
                          if (controller.isselected) {
                            await controller.uploadFile(
                                filePath: controller.path,
                                userid: logininfo.get('userid'));
                          }
                          await controller.updateData(
                              name: name.text.toString());
                        } on FirebaseException catch (e) {
                          Get.back();

                          styledsnackbar(
                              txt: 'Error occured. $e', icon: Icons.error);
                          // Get.snackbar('Error occured.', '');
                        }
                      }
                    : () {
                        FocusScope.of(context).requestFocus(namefocusnode);
                        controller.isedit = true;
                        controller.update();
                      },
                child: Icon(
                  controller.isedit ? Icons.check : Icons.edit,
                  color: Colors.white,
                  size: 25.0,
                ),
              ),
            );
          }),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: logininfo.listenable(),
          builder: (context, box, _) {
            return Container(
              // height: height,
              // width: width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0XFFd66d75),
                  Color(0XFFe29587),
                ],
              )),
              child: GetBuilder<ProfileController>(builder: (controller) {
                return Form(
                  key: formkey,
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: InkWell(
                          onTap: () {
                            filepicker().then((selectedpath) {
                              if (selectedpath.toString().isNotEmpty) {
                                controller.path = selectedpath;
                                controller.isselected = true;
                                controller.update();
                              }
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 45.0,
                            child: controller.isselected
                                ? CircleAvatar(
                                    radius: 40.0,
                                    foregroundImage:
                                        FileImage(File(controller.path)),
                                    backgroundColor: Colors.transparent,
                                    child: Icon(
                                      CupertinoIcons.profile_circled,
                                      size: 80.0,
                                      color: Colors.black,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 40.0,
                                    foregroundImage: CachedNetworkImageProvider(
                                        logininfo.get('img') ?? ''),
                                    backgroundColor: Colors.transparent,
                                    child: Icon(
                                      CupertinoIcons.profile_circled,
                                      size: 80.0,
                                      color: Colors.black,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      customTextField(
                          "Name",
                          false,
                          null,
                          name,
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
                            name.text = value!;
                          },
                          responsiveHW(context, wd: 100),
                          responsiveHW(context, ht: 70),
                          controller.isedit
                              ? const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                )
                              : InputBorder.none,
                          pIcon: Icons.person_outline,
                          piconcolor: Colors.white,
                          textcolor: Colors.white,
                          focusnode: namefocusnode,
                          readonly: !controller.isedit,
                          onsubmit: (val) {
                            namefocusnode.unfocus();
                            FocusScope.of(context).requestFocus(emailfocusnode);
                          }),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      customTextField(
                        "Email",
                        false,
                        controller.isedit
                            ? null
                            : InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => changeEmailDialog(),
                                  );
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                        email,
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
                          email.text = value!;
                        },
                        responsiveHW(context, wd: 100),
                        responsiveHW(context, ht: 70),
                        // controller.isedit
                        //     ? const OutlineInputBorder(
                        //         borderSide: BorderSide(
                        //           color: Colors.white,
                        //         ),
                        //       )
                        //     :
                        InputBorder.none,
                        pIcon: Icons.email_outlined,

                        piconcolor: Colors.white,
                        textcolor: Colors.white,
                        readonly: true,
                      ),
                      SizedBox(
                        height: context.blockSizeVertical * 2.5,
                      ),
                    ],
                  ),
                );
              }),
            );
          }),
    );
  }
}
