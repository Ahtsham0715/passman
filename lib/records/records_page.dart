import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:passman/Auth/controllers/user_data_controller.dart';
import 'package:passman/Auth/login_page.dart';
import 'package:passman/profile/user_profile.dart';
import 'package:passman/records/create_new_record_page.dart';
import 'package:passman/records/models/password_model.dart';
import 'package:passman/records/record_details_page.dart';
import 'package:passman/res/components/custom_text.dart';
import 'package:encrypt/encrypt.dart' as encryption;
import '../constants.dart';
import '../res/components/custom_snackbar.dart';

class PasswordsPage extends StatefulWidget {
  const PasswordsPage({super.key});

  @override
  State<PasswordsPage> createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  final ScrollController scrollcont = ScrollController();
  bool bioauth = logininfo.get('bio_auth') ?? false;
  // ValueNotifier<bool> isScrolling = ValueNotifier(true);
  @override
  void initState() {
    super.initState();
    Get.put(UserDataController());

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null || user.isAnonymous) {
        print('User is currently signed out!');
        Get.to(
          () => LoginPage(),
        );
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final UserDataController userdata = UserDataController();
    return WillPopScope(
      onWillPop: () async {
        AwesomeDialog(
          context: context,
          animType: AnimType.topSlide,
          dialogType: DialogType.question,
          title: 'Are you sure?',
          desc: 'Do you want to exit the app?',
          btnOkOnPress: () async {
            try {
              SystemNavigator.pop();
            } catch (e) {
              styledsnackbar(txt: 'Error Occured. $e', icon: Icons.error);
            }
          },
          btnCancelOnPress: () {},
        )..show();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          foregroundColor: Colors.white,
          // backgroundColor: Colors.green,
          elevation: 0.0,
          centerTitle: true,
          title: const Text(
            'My Records',
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'majalla'),
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
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.to(
              () => CreateRecord(
                passwordData: PasswordModel(
                    title: '',
                    login: '',
                    password: '',
                    website: '',
                    notes: '',
                    length: 0),
                edit: false,
              ),
            );
          },
          elevation: 0.0,

          // shape: scrolling ? null : const CircleBorder(),
          label: const CustomText(
              fontcolor: Colors.white,
              title: 'Password',
              fontweight: FontWeight.w500,
              fontsize: 22.0),
          backgroundColor: Colors.green.shade400,

          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: 25.0,
          ),
        ),
        body: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color(0XFFd66d75),
              Color(0XFFe29587),
            ],
          )),
          child: ValueListenableBuilder(
              valueListenable: Hive.box<PasswordModel>('my_data').listenable(),
              builder: (context, box, _) {
                return box.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.flaskEmptyOutline,
                            size: 50.0,
                            color: Colors.white,
                          ),
                          CustomText(
                              title: 'No Data Available',
                              fontcolor: Colors.white,
                              fontweight: FontWeight.w600,
                              fontsize: 40.0),
                        ],
                      )
                    : ListView.separated(
                        controller: scrollcont,
                        separatorBuilder: (context, index) {
                          return const Divider(
                            color: Colors.white,
                            thickness: 0.5,
                          );
                        },
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          // print(box.getAt(index)?.title.toString());
                          // print(box.keyAt(index)?.toString());
                          var data = box.getAt(index);
                          return ListTile(
                            onTap: () {
                              Get.to(
                                () => RecordDetails(
                                  password: data,
                                  passwordIndex: index,
                                  passwordKey: box.keyAt(index).toString(),
                                ),
                              );
                            },
                            dense: true,
                            leading: websites
                                    .containsKey(data!.title.toString())
                                ? SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: SvgPicture.asset(
                                        'assets/icons/${data.title.toString().toLowerCase()}.svg'))
                                : Icon(
                                    FontAwesomeIcons.unlockKeyhole,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                            title: CustomText(
                                title: data.title.toString(),
                                fontcolor: Colors.white,
                                fontweight: FontWeight.w500,
                                fontsize: 23.0),
                            subtitle: CustomText(
                                title: encrypter.decrypt(
                                    encryption.Encrypted.from64(
                                        data.login.toString()),
                                    iv: iv),
                                fontcolor: Colors.white,
                                fontweight: FontWeight.w500,
                                fontsize: 20.0),
                            trailing: InkWell(
                              onTap: () async {
                                await Clipboard.setData(ClipboardData(
                                  text: encrypter.decrypt(
                                      encryption.Encrypted.from64(
                                          data.password.toString()),
                                      iv: iv),
                                ));
                                styledsnackbar(
                                    txt: 'Copied to clipboard',
                                    icon: Icons.copy_rounded);
                              },
                              child: const Icon(
                                Icons.copy,
                                color: Colors.white,
                                size: 25.0,
                              ),
                            ),
                          );
                        },
                      );
              }),
        ),
        drawer: Drawer(
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.only(
          //     topRight: Radius.circular(100.0),
          //     bottomRight: Radius.circular(100.0),
          //   ),
          // ),
          child: ValueListenableBuilder(
              valueListenable: logininfo.listenable(),
              builder: (context, box, _) {
                return Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0XFFd66d75),
                        Color(0XFFe29587),
                      ],
                    )),
                    child: Column(
                      children: [
                        UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.vertical(
                            //   bottom: Radius.circular(20.0),
                            // ),
                            color: Colors.black26,
                          ),
                          accountName: Text(
                            box.get('name') ?? '',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          accountEmail: Text(
                            encrypter.decrypt(
                                encryption.Encrypted.from64(box.get('email')),
                                iv: iv),
                            style: TextStyle(fontSize: 20.0),
                          ),
                          currentAccountPicture: CircleAvatar(
                            // radius: 30.0,
                            foregroundImage: CachedNetworkImageProvider(
                                box.get('img') ?? ''),
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              CupertinoIcons.profile_circled,
                              size: 70.0,
                              color: Colors.white,
                            ),
                          ),
                          currentAccountPictureSize: Size.square(70.0),
                        ),

                        SwitchListTile(
                          value: bioauth,
                          inactiveTrackColor:
                              Color.fromARGB(255, 228, 151, 157),
                          activeColor: Colors.green,
                          title: CustomText(
                              fontcolor: Colors.white,
                              title: 'Fingerprint Login',
                              fontweight: FontWeight.w500,
                              fontsize: 22.0),
                          onChanged: (value) {
                            logininfo.put('bio_auth', value);

                            print(logininfo.get('bio_auth'));
                            setState(() {
                              bioauth = value;
                            });
                            if (value) {
                              styledsnackbar(
                                  txt:
                                      'Next time you can login using fingerprint',
                                  icon: Icons.login);
                            }
                          },
                        ),
                        CustomDivider(),
                        customDrawerTile(
                          title: 'Profile',
                          leading: Icons.group,
                          onpressed: () {
                            Get.to(
                              () => UserProfile(),
                            );
                          },
                        ),
                        CustomDivider(),

                        // customDrawerTile(
                        //   title: 'Start Match',
                        //   leading: Icons.arrow_right,
                        //   onpressed: () {},
                        // ),
                        customDrawerTile(
                          title: 'Logout',
                          leading: Icons.power_settings_new,
                          onpressed: () async {
                            // logout(context);
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
                                      txt: 'user logged out.',
                                      icon: Icons.logout_outlined);
                                } catch (e) {
                                  //  Get.back();

                                  styledsnackbar(
                                      txt: 'Error Occured. $e',
                                      icon: Icons.error);
                                }
                              },
                              btnCancelOnPress: () {
                                // Get.back();
                              },
                            )..show();
                            // logout_func();
                          },
                        )
                      ],
                    ));
              }),
          // backgroundColor: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.black26,
      thickness: 0.25,
    );
  }
}

class customDrawerTile extends StatelessWidget {
  final VoidCallback onpressed;
  final String title;
  final IconData leading;
  const customDrawerTile(
      {super.key,
      required this.onpressed,
      required this.title,
      required this.leading});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onpressed,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25.0,
        ),
      ),
      leading: Icon(
        leading,
        size: 25.0,
        color: Colors.white,
      ),
    );
  }
}
