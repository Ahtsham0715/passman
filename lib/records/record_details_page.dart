import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:passman/Auth/controllers/auth_controller.dart';
import 'package:passman/constants.dart';
import 'package:passman/records/create_new_record_page.dart';
import 'package:passman/records/models/password_model.dart';
import 'package:passman/res/components/custom_snackbar.dart';
import 'package:passman/res/components/custom_text.dart';
import 'package:encrypt/encrypt.dart' as encryption;

class RecordDetails extends StatefulWidget {
  final PasswordModel password;
  final int passwordIndex;
  final String passwordKey;
  const RecordDetails(
      {Key? key,
      required this.password,
      required this.passwordIndex,
      required this.passwordKey})
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
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
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
                // PopupMenuItem<String>(value: "2", child: Text("Leave a review")),
                // PopupMenuItem<String>(value: "3", child: Text("Share")),
                // PopupMenuItem<String>(value: "4", child: Text("Exit")),
              ];
            },
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (i) {
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
                  // body: Center(child: Text(
                  //         'If the body is specified, then title and description will be ignored, this allows to 											further customize the dialogue.',
                  //         style: TextStyle(fontStyle: FontStyle.italic),
                  //       ),),
                  title: 'Are you sure?',
                  desc: 'Do you want to delete this data?',
                  btnOkOnPress: () async {
                    try {
                      await passwordbox.deleteAt(widget.passwordIndex);
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
                //  displayBar(context, i);
              }
              //  else if(i == "3"){
              //    displayBar(context, i);
              //  }
              //  else if(i == "4"){
              //    displayBar(context, i);
              //  }
              else {}
            },
            // onCanceled: () => displayBar(context,"Cancelled",cancel: true),
          ),
        ],
      ),
      body: Container(
        width: width,
        height: height,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTile(
                    title: widget.password.title.toString(),
                    icon: Icons.note_alt_sharp),
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
                          final LocalAuthentication auth =
                              LocalAuthentication();
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
                                styledsnackbar(
                                    txt: encrypter.decrypt(
                                        encryption.Encrypted.from64(widget
                                            .password.password
                                            .toString()),
                                        iv: iv),
                                    icon: Icons.visibility);
                              }
                            });
                          } on PlatformException catch (e) {
                            styledsnackbar(
                                txt: 'Error occured. $e', icon: Icons.error);
                            if (kDebugMode) {
                              print(e);
                              styledsnackbar(
                                  txt: 'Error occured. $e', icon: Icons.error);
                            }

                            return;
                          }
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
                          await Clipboard.setData(ClipboardData(
                            text: encrypter.decrypt(
                                encryption.Encrypted.from64(
                                    widget.password.password.toString()),
                                iv: iv),
                          ));
                          styledsnackbar(
                              txt: 'Copied to clipboard',
                              icon: Icons.copy_rounded);
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
  const CustomTile({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
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
      indent: width * 0.15,
      endIndent: 0,
    );
  }
}
