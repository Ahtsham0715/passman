import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:passman/Auth/controllers/auth_controller.dart';
import 'package:passman/constants.dart';
import 'package:passman/records/controllers/records_controller.dart';
import 'package:passman/records/create_new_record_page.dart';
import 'package:passman/records/models/password_model.dart';
import 'package:passman/res/components/custom_snackbar.dart';
import 'package:passman/res/components/custom_text.dart';
import 'package:encrypt/encrypt.dart' as encryption;
import 'package:passman/res/extensions.dart';

import '../res/components/master_password_dialog.dart';

class RecordDetails extends StatefulWidget {
  final PasswordModel password;
  // final int passwordIndex;
  final String passwordKey;
  final String img;
  const RecordDetails(
      {Key? key,
      required this.password,
      // required this.passwordIndex,
      required this.passwordKey,
      required this.img})
      : super(key: key);

  @override
  _RecordDetailsState createState() => _RecordDetailsState();
}

class _RecordDetailsState extends State<RecordDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RecordsController recordscontroller = Get.put(RecordsController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Details'),
        elevation: 0.0,
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
          PopupMenuButton<String>(
            itemBuilder: (_) {
              return const [
                PopupMenuItem<String>(
                    value: "1",
                    child: Text(
                      "Edit",
                      style: TextStyle(fontSize: 20.0),
                    )),
                PopupMenuItem<String>(
                    value: "2",
                    child: Text(
                      "Delete",
                      style: TextStyle(fontSize: 20.0),
                    )),
              ];
            },
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (i) async {
              if (i == "1") {
                Get.to(
                  () => CreateRecord(
                    passwordData: PasswordModel(
                      title: widget.password.title.toString(),
                      login: encrypter.decrypt(
                          encryption.Encrypted.from64(
                              widget.password.login.toString()),
                          iv: iv),
                      password: encrypter.decrypt(
                          encryption.Encrypted.from64(
                              widget.password.password.toString()),
                          iv: iv),
                      website: widget.password.website.toString(),
                      notes: widget.password.notes.toString(),
                      length: widget.password.length,
                    ),
                    passwordIndex: widget.passwordKey.toString(),
                    edit: true,
                  ),
                );

                //  displayBar(context, i);
              } else if (i == "2") {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.topSlide,
                  dialogType: DialogType.question,
                  title: 'Are you sure?',
                  desc: 'Do you want to delete this data?',
                  btnOkOnPress: () async {
                    try {
                      await passwordbox.delete(widget.passwordKey);
                      Get.back();

                      styledsnackbar(
                          txt: 'Password Deleted Successfully.',
                          icon: MdiIcons.check);
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
              } else {}
            },
          ),
        ],
      ),
      body: Container(
        // width: width,
        // height: height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Color(0XFFd66d75),
            Color(0XFFe29587),
          ],
        )),
        child: FadeTransition(
          opacity: _animation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTile(
                  title: widget.password.title.toString(),
                  icon: FontAwesomeIcons.unlockKeyhole,
                  img: widget.img,
                ),
                CustomDivider(),
                CustomTile(
                    title: widget.password.website.toString(),
                    icon: MdiIcons.web),
                CustomDivider(),
                CustomTile(
                    title: encrypter.decrypt(
                        encryption.Encrypted.from64(
                            widget.password.login.toString()),
                        iv: iv),
                    icon: MdiIcons.key),
                CustomDivider(),
                ListTile(
                  title: CustomText(
                      // fontcolor: Colors.white,
                      title: encrypter
                              .decrypt(
                                  encryption.Encrypted.from64(
                                      widget.password.password.toString()),
                                  iv: iv)
                              .substring(0, 2) +
                          ('*' * (widget.password.length!.toInt() - 2)),
                      fontweight: FontWeight.w500,
                      fontsize: 25.0),
                  trailing: ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          !logininfo.get('is_biometric_available') ||
                                  !logininfo.get('bio_auth')
                              ? showDialog(
                                  context: context,
                                  builder: (context) => MasterPasswordDialog(),
                                ).then((value) {
                                  if (value != null) {
                                    if (value ==
                                        encrypter.decrypt(
                                            encryption.Encrypted.from64(
                                                logininfo.get('password')),
                                            iv: iv)) {
                                      styledsnackbar(
                                          txt: encrypter.decrypt(
                                              encryption.Encrypted.from64(widget
                                                  .password.password
                                                  .toString()),
                                              iv: iv),
                                          icon: Icons.visibility);
                                    } else {
                                      styledsnackbar(
                                          txt: 'Incorrect master password',
                                          icon: Icons.error_outlined);
                                    }
                                  }
                                })
                              : await recordscontroller
                                  .authenticateWithBiometrics()
                                  .then((value) async {
                                  if (recordscontroller.isauthenticated.value) {
                                    styledsnackbar(
                                        txt: encrypter.decrypt(
                                            encryption.Encrypted.from64(widget
                                                .password.password
                                                .toString()),
                                            iv: iv),
                                        icon: Icons.visibility);
                                  }
                                });
                        },
                        child: Icon(
                          Icons.visibility,
                          size: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox.shrink(),
                      InkWell(
                        onTap: () async {
                          !logininfo.get('is_biometric_available') ||
                                  !logininfo.get('bio_auth')
                              ? showDialog(
                                  context: context,
                                  builder: (context) => MasterPasswordDialog(),
                                ).then((value) async {
                                  if (value != null) {
                                    if (value ==
                                        encrypter.decrypt(
                                            encryption.Encrypted.from64(
                                                logininfo.get('password')),
                                            iv: iv)) {
                                      await Clipboard.setData(ClipboardData(
                                        text: encrypter.decrypt(
                                            encryption.Encrypted.from64(widget
                                                .password.password
                                                .toString()),
                                            iv: iv),
                                      ));
                                      styledsnackbar(
                                          txt: 'Copied to clipboard',
                                          icon: Icons.copy_rounded);
                                    } else {
                                      styledsnackbar(
                                          txt: 'Incorrect master password',
                                          icon: Icons.error_outlined);
                                    }
                                  }
                                })
                              : await recordscontroller
                                  .authenticateWithBiometrics()
                                  .then((value) async {
                                  if (recordscontroller.isauthenticated.value) {
                                    await Clipboard.setData(ClipboardData(
                                      text: encrypter.decrypt(
                                          encryption.Encrypted.from64(widget
                                              .password.password
                                              .toString()),
                                          iv: iv),
                                    ));
                                    styledsnackbar(
                                        txt: 'Copied to clipboard',
                                        icon: Icons.copy_rounded);
                                  }
                                });
                        },
                        child: Icon(
                          Icons.copy_rounded,
                          size: 25.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  //  ),
                ),
                CustomDivider(),
                CustomTile(
                    title: widget.password.notes.toString(),
                    icon: MdiIcons.noteEdit),
                CustomDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String img;
  const CustomTile(
      {super.key, required this.title, required this.icon, this.img = ''});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: img.toString().isNotEmpty
          ? SizedBox(
              height: 30, width: 30, child: SvgPicture.asset(img.toString()))
          : Icon(
              icon,
              size: 25.0,
              color: Colors.white,
            ),
      title: CustomText(
          fontcolor: Colors.white,
          title: title,
          fontweight: FontWeight.w500,
          fontsize: 22.0),
      //  ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.white,
      thickness: 1.0,
      indent: context.blockSizeHorizontal * 20,
      endIndent: 0,
    );
  }
}
