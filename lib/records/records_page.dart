import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:passman/records/create_new_record_page.dart';
import 'package:passman/records/models/password_model.dart';
import 'package:passman/records/record_details_page.dart';
import 'package:passman/res/components/custom_text.dart';
import 'package:passman/res/components/onwillpop.dart';

import '../constants.dart';

class PasswordsPage extends StatefulWidget {
  const PasswordsPage({super.key});

  @override
  State<PasswordsPage> createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  final ScrollController scrollcont = ScrollController();
  // ValueNotifier<bool> isScrolling = ValueNotifier(true);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return onWillPop(context);
      },
      child: Scaffold(
        // backgroundColor: Colors.teal.shade100,
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
              () => const CreateRecord(),
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
                          print(box.getAt(index)?.title.toString());
                          var data = box.getAt(index);
                          return ListTile(
                            onTap: () {
                              Get.to(
                                () => RecordDetails(password: data),
                              );
                            },
                            dense: true,
                            leading: const Icon(
                              FontAwesomeIcons.facebook,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            title: CustomText(
                                title: data!.title.toString(),
                                fontcolor: Colors.white,
                                fontweight: FontWeight.w600,
                                fontsize: 23.0),
                            subtitle: CustomText(
                                title: data.login.toString(),
                                fontcolor: Colors.white,
                                fontweight: FontWeight.w500,
                                fontsize: 20.0),
                            trailing: const Icon(
                              Icons.copy,
                              color: Colors.white,
                              size: 25.0,
                            ),
                          );
                        },
                      );
              }),
        ),
        drawer: Drawer(
          child: Container(
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
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20.0),
                      ),
                      color: Colors.grey,
                    ),
                    accountName: Text('shami'),
                    accountEmail: Text('shami@gmail.com'),
                    currentAccountPicture: CircleAvatar(
                      foregroundImage: CachedNetworkImageProvider(''),
                      backgroundColor: Colors.grey,
                      child: Icon(
                        CupertinoIcons.profile_circled,
                        size: 80.0,
                        color: Colors.white,
                      ),
                    ),
                    currentAccountPictureSize: Size.square(80.0),
                  ),
                  customDrawerTile(
                    title: 'Profile',
                    leading: Icons.group,
                    onpressed: () {},
                  ),
                  // customDrawerTile(
                  //   title: 'Start Match',
                  //   leading: Icons.arrow_right,
                  //   onpressed: () {},
                  // ),
                  customDrawerTile(
                    title: 'Logout',
                    leading: Icons.power_settings_new,
                    onpressed: () {
                      // logout_func();
                    },
                  )
                ],
              )),
          // backgroundColor: Colors.white.withOpacity(0.9),
        ),
      ),
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
