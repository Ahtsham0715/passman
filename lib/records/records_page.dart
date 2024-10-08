
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:passman/Auth/controllers/user_data_controller.dart';
import 'package:passman/Auth/login_page.dart';
import 'package:passman/profile/user_profile.dart';
import 'package:passman/records/controllers/records_controller.dart';
import 'package:passman/records/create_new_record_page.dart';
import 'package:passman/records/models/password_model.dart';
import 'package:passman/records/record_details_page.dart';
import 'package:passman/records/settings_page.dart';
import 'package:passman/res/components/awesome_custom_dialog.dart';
import 'package:passman/res/components/custom_text.dart';
import 'package:encrypt/encrypt.dart' as encryption;
import 'package:passman/res/components/new_folder.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import '../constants.dart';
import '../media files/controllers/media_controller.dart';
import '../media files/folder_view.dart';
import '../res/components/custom_formfield.dart';
import '../res/components/custom_snackbar.dart';
import '../res/components/loading_page.dart';

import '../res/components/master_password_dialog.dart';

final _shorebirdCodePush = ShorebirdCodePush();

class PasswordsPage extends StatefulWidget {
  const PasswordsPage({super.key});

  @override
  State<PasswordsPage> createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  final ScrollController scrollcont = ScrollController();

  final searchController = TextEditingController();

  final _isShorebirdAvailable = _shorebirdCodePush.isShorebirdAvailable();
  int? _currentPatchVersion;
  // bool _isCheckingForUpdate = false;
  // ValueNotifier<bool> isScrolling = ValueNotifier(true);
  @override
  void initState() {
    super.initState();

    Get.put(UserDataController());
    _shorebirdCodePush.currentPatchNumber().then((currentPatchVersion) {
      if (!mounted) return;
      setState(() {
        _currentPatchVersion = currentPatchVersion;
      });
    });
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
    print('is shorebird available: $_isShorebirdAvailable');
    if (_isShorebirdAvailable) {
      _checkForUpdate();
    }
  }

  Future<void> _checkForUpdate({bool showSnackbar = false}) async {
    // setState(() {
    //   _isCheckingForUpdate = true;
    // });

    // Ask the Shorebird servers if there is a new patch available.
    final isUpdateAvailable =
        await _shorebirdCodePush.isNewPatchAvailableForDownload();

    if (!mounted) return;

    // setState(() {
    //   _isCheckingForUpdate = false;
    // });

    if (isUpdateAvailable) {
      // _showUpdateAvailableBanner();
      _downloadUpdate();
    } else {
      print('no update available');
      if (showSnackbar) {
        styledsnackbar(txt: 'No update available', icon: Icons.update);
      }
    }
  }

  // void _showDownloadingBanner() {
  //   ScaffoldMessenger.of(context).showMaterialBanner(
  //       // const MaterialBanner(
  //       //   content: CustomText(title: 'Downloading...', fontcolor: Colors.white),
  //       //   backgroundColor: Colors.transparent,
  //       //   actions: [
  //       //     SizedBox(
  //       //       height: 14,
  //       //       width: 14,
  //       //       child: CircularProgressIndicator(
  //       //         strokeWidth: 2,
  //       //       ),
  //       //     ),
  //       //   ],
  //       // ),

  //       customMaterialBanner(
  //     title: 'Downloading... ',
  //   ));
  // }

  // void _showUpdateAvailableBanner() {
  //   ScaffoldMessenger.of(context).showMaterialBanner(customMaterialBanner(
  //     title: 'Update available',
  //     actions: [
  //       TextButton(
  //         onPressed: () async {
  //           ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  //           await _downloadUpdate();

  //           if (!mounted) return;
  //           ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  //         },
  //         child: CustomText(
  //           title: 'Download',
  //           fontsize: 18,
  //           fontcolor: Colors.blue,
  //         ),
  //       ),
  //     ],
  //   )
  //       // MaterialBanner(
  //       //   content: const Text('Update available'),
  //       //   actions: [
  //       //     TextButton(
  //       //       onPressed: () async {
  //       //         ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  //       //         await _downloadUpdate();

  //       //         if (!mounted) return;
  //       //         ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  //       //       },
  //       //       child: const Text('Download'),
  //       //     ),
  //       //   ],
  //       // ),
  //       );
  // }

  // void _showRestartBanner() {
  //   ScaffoldMessenger.of(context).showMaterialBanner(customMaterialBanner(
  //     title: 'A new patch is ready!',
  //     actions: [
  //       TextButton(
  //         // Restart the app for the new patch to take effect.
  //         onPressed: () {
  //           ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  //           Restart.restartApp();
  //         },

  //         child: CustomText(
  //           title: 'Restart app',
  //           fontsize: 18,
  //           fontcolor: Colors.blue,
  //         ),
  //       ),
  //     ],
  //   )
  //       // const MaterialBanner(
  //       //   content: Text('A new patch is ready!'),
  //       //   actions: [
  //       //     TextButton(
  //       //       // Restart the app for the new patch to take effect.
  //       //       onPressed: Restart.restartApp,
  //       //       child: Text('Restart app'),
  //       //     ),
  //       //   ],
  //       // ),
  //       );
  // }

  Future<void> _downloadUpdate() async {
    // _showDownloadingBanner();

    await Future.wait([
      _shorebirdCodePush.downloadUpdateIfAvailable(),

      // Add an artificial delay so the banner has enough time to animate in.
      Future<void>.delayed(const Duration(milliseconds: 250)),
    ]);

    if (!mounted) return;
    Restart.restartApp();
    // ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    // _showRestartBanner();
  }

  @override
  Widget build(BuildContext context) {
    // final UserDataController userdata = UserDataController();
    final RecordsController recordscontroller = Get.put(RecordsController());
    final MediaController folderscontroller = Get.put(MediaController());
    final heading = _currentPatchVersion != null
        ? '$_currentPatchVersion'
        : 'No patch installed';
    return PopScope(
      canPop: false,
      onPopInvoked: (val) {
        customAwesomeDialog(
            details: 'Do you want to exit the App',
            okpress: () => SystemNavigator.pop());
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          foregroundColor: Colors.white,
          // backgroundColor: Colors.green,
          elevation: 0.0,
          centerTitle: true,
          title: GetBuilder<RecordsController>(
            builder: (controller) {
              return controller.isSearchBarVisible
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: customTextField(
                          'Search',
                          false,
                          null,
                          searchController,
                          (val) {},
                          (val) {},
                          Get.width * 0.5,
                          Get.height * 0.2,
                          OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          textcolor: Colors.white, onchanged: (val) {
                        print(searchController.text);
                        if (searchController.text.isEmpty) {
                          controller.combinedata();
                          controller.update();
                        } else {
                          List templist = controller.box;
                          controller.box = [];
                          // print(templist);
                          templist.forEach((element) {
                            if (element['title']
                                .toString()
                                .toLowerCase()
                                .startsWith(
                                    searchController.text.toLowerCase())) {
                              controller.box.add(element);
                            }
                          });
                          // print(controller.box);
                          controller.update();
                        }
                      }),
                    )
                  : const Text(
                      'My Records',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'majalla'),
                    );
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0XFFd66d75),
                  Color(0XFFe29587),
                ],
                begin:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? Alignment.bottomCenter
                        : Alignment.bottomLeft,
                end: MediaQuery.of(context).orientation == Orientation.portrait
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
              ),
            ),
          ),
          actions: [
            GetBuilder<RecordsController>(
                // assignId: true,
                // id: 'records_builder',
                builder: (controller) {
              return recordscontroller.isSearchBarVisible
                  ? IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        searchController.clear();
                        controller.isSearchBarVisible = false;
                        controller.combinedata();
                        controller.update();
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        controller.isSearchBarVisible = true;
                        controller.update();
                      },
                    );
            }),
          ],
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: Colors.green,
          activeBackgroundColor: Colors.red,
          elevation: 0.0,
          activeChild: Icon(
            Icons.close,
            color: Colors.white,
          ),
          closeDialOnPop: true,
          spaceBetweenChildren: 20.0,
          tooltip: 'Create New Folder/Password',
          renderOverlay: false,
          label: const CustomText(
              fontcolor: Colors.white,
              title: 'Create',
              fontweight: FontWeight.w500,
              fontsize: 22.0),
          activeLabel: const CustomText(
              fontcolor: Colors.white,
              title: 'Close',
              fontweight: FontWeight.w500,
              fontsize: 22.0),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.lock_outline,
                size: 25.0,
              ),
              elevation: 0.0,
              labelBackgroundColor: Colors.black.withOpacity(0.7),
              backgroundColor: Colors.black.withOpacity(0.7),
              label: "New Password",
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                  color: Colors.white),
              foregroundColor: Colors.white,
              onTap: () {
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
            ),
            SpeedDialChild(
              child: Icon(
                Icons.folder_open_rounded,
                size: 25.0,
              ),
              labelBackgroundColor: Colors.black.withOpacity(0.7),
              backgroundColor: Colors.black.withOpacity(0.7),
              foregroundColor: Colors.white,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
                color: Colors.white,
              ),
              label: "New Folder",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => showNewFolderDialog(
                    name: '',
                    type: 'Images',
                    isEdit: false,
                  ),
                ).then((value) async {
                  if (value != null) {
                    Get.dialog(LoadingPage());
                    await folderscontroller
                        .createFolder(
                          folderName: value['name'].toString(),
                          folderType: value['type'].toString(),
                        )
                        .then((value) {});
                  }
                });
              },
            ),
          ],
        ),
        body: Container(
          // height: context.blockSizeVertical * 100,
          // width: context.blockSizeHorizontal * 100,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color(0XFFd66d75),
              Color(0XFFe29587),
            ],
          )),
          child: GetBuilder<RecordsController>(builder: (controller) {
            // controller.combinedata();
            return controller.box.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Icon(
                          MdiIcons.flaskEmptyOutline,
                          size: 50.0,
                          color: Colors.white,
                        ),
                      ),
                      Center(
                        child: CustomText(
                            title: 'No Data Available',
                            fontcolor: Colors.white,
                            fontweight: FontWeight.w600,
                            fontsize: 40.0),
                      ),
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
                    itemCount: controller.box.length + 1,
                    itemBuilder: (context, index) {
                      // print(box.getAt(index)?.title.toString());
                      // print(box.keyAt(index)?.toString());
                      dynamic data;

                      index == 0
                          ? data = controller.box[index]
                          : data = controller.box[index - 1];
                      return index == 0
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 25.0),
                              child: CustomText(
                                  fontcolor: Colors.white,
                                  title:
                                      'Total Records: ${controller.box.length.toString()}',
                                  fontweight: FontWeight.w500,
                                  fontsize: 27.0),
                            )
                          : ListTile(
                              onLongPress: data['isfolder']
                                  ? () {
                                      // foldersbox.delete(data['key']);
                                      // print('deleted');
                                    }
                                  : () {},
                              onTap: () async {
                                !logininfo.get('is_biometric_available') ||
                                        !logininfo.get('bio_auth')
                                    ? showDialog(
                                        context: context,
                                        builder: (context) =>
                                            MasterPasswordDialog(),
                                      ).then((value) async {
                                        if (value != null) {
                                          if (value ==
                                              encrypter.decrypt(
                                                  encryption.Encrypted.from64(
                                                      logininfo
                                                          .get('password')),
                                                  iv: iv)) {
                                            data['isfolder']
                                                ? Get.to(
                                                    () => FolderView(
                                                      folderKey: data['key'],
                                                      folderName: data['title'],
                                                      folderType: data['value']
                                                          ['type'],
                                                    ),
                                                  )
                                                : Get.to(
                                                    () => RecordDetails(
                                                      password: data['value'],
                                                      // passwordIndex:
                                                      //     index == 0 ? index : index - 1,
                                                      passwordKey: data['key'],
                                                      // controller.box
                                                      //     .keyAt(index == 0
                                                      //         ? index
                                                      //         : index - 1)
                                                      //     .toString(),
                                                      img: websites.containsKey(
                                                              data['value']!
                                                                  .title
                                                                  .toString())
                                                          ? 'assets/icons/${data['value'].title.toString().toLowerCase()}.svg'
                                                          : '',
                                                    ),
                                                  );
                                          } else {
                                            styledsnackbar(
                                                txt:
                                                    'Incorrect master password',
                                                icon: Icons.error_outlined);
                                          }
                                        }
                                      })
                                    : await recordscontroller
                                        .authenticateWithBiometrics()
                                        .then((value) async {
                                        if (recordscontroller
                                            .isauthenticated.value) {
                                          data['isfolder']
                                              ? Get.to(
                                                  () => FolderView(
                                                    folderKey: data['key'],
                                                    folderName: data['title'],
                                                    folderType: data['value']
                                                        ['type'],
                                                  ),
                                                )
                                              : Get.to(
                                                  () => RecordDetails(
                                                    password: data['value'],
                                                    // passwordIndex:
                                                    //     index == 0 ? index : index - 1,
                                                    passwordKey: data['key'],
                                                    // controller.box
                                                    //     .keyAt(index == 0
                                                    //         ? index
                                                    //         : index - 1)
                                                    //     .toString(),
                                                    img: websites.containsKey(
                                                            data['value']!
                                                                .title
                                                                .toString())
                                                        ? 'assets/icons/${data['value'].title.toString().toLowerCase()}.svg'
                                                        : '',
                                                  ),
                                                );
                                        }
                                      });
                              },
                              dense: true,
                              leading: data['isfolder']
                                  ? Icon(
                                      FontAwesomeIcons.folder,
                                      color: Colors.white,
                                      size: 30.0,
                                    )
                                  : websites.containsKey(
                                          data['value']!.title.toString())
                                      ? SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: SvgPicture.asset(
                                            'assets/icons/${data['value'].title.toString().toLowerCase()}.svg',
                                            placeholderBuilder: (context) {
                                              return Icon(
                                                FontAwesomeIcons.unlockKeyhole,
                                                color: Colors.white,
                                                size: 30.0,
                                              );
                                            },
                                          ))
                                      : Icon(
                                          FontAwesomeIcons.unlockKeyhole,
                                          color: Colors.white,
                                          size: 30.0,
                                        ),
                              title: CustomText(
                                  title: data['isfolder']
                                      ? data['title'].toString()
                                      : data['value'].title.toString(),
                                  fontcolor: Colors.white,
                                  fontweight: FontWeight.w500,
                                  fontsize: 23.0),
                              subtitle: CustomText(
                                  title: data['isfolder']
                                      ? data['value']['type'].toString()
                                      : encrypter.decrypt(
                                          encryption.Encrypted.from64(
                                              data['value'].login.toString()),
                                          iv: iv),
                                  fontcolor: Colors.white,
                                  fontweight: FontWeight.w500,
                                  fontsize: 20.0),
                              trailing: data['isfolder']
                                  ? null
                                  : InkWell(
                                      onTap: () async {
                                        !logininfo.get(
                                                    'is_biometric_available') ||
                                                !logininfo.get('bio_auth')
                                            ? showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    MasterPasswordDialog(),
                                              ).then((value) async {
                                                if (value != null) {
                                                  if (value ==
                                                      encrypter.decrypt(
                                                          encryption.Encrypted
                                                              .from64(
                                                                  logininfo.get(
                                                                      'password')),
                                                          iv: iv)) {
                                                    await Clipboard.setData(
                                                        ClipboardData(
                                                      text: encrypter.decrypt(
                                                          encryption.Encrypted
                                                              .from64(data[
                                                                      'value']
                                                                  .password
                                                                  .toString()),
                                                          iv: iv),
                                                    ));
                                                    styledsnackbar(
                                                        txt:
                                                            'Copied to clipboard',
                                                        icon:
                                                            Icons.copy_rounded);
                                                  } else {
                                                    styledsnackbar(
                                                        txt:
                                                            'Incorrect master password',
                                                        icon: Icons
                                                            .error_outlined);
                                                  }
                                                }
                                              })
                                            : await recordscontroller
                                                .authenticateWithBiometrics()
                                                .then((value) async {
                                                if (recordscontroller
                                                    .isauthenticated.value) {
                                                  await Clipboard.setData(
                                                      ClipboardData(
                                                    text: encrypter.decrypt(
                                                        encryption.Encrypted
                                                            .from64(data[
                                                                    'value']
                                                                .password
                                                                .toString()),
                                                        iv: iv),
                                                  ));
                                                  styledsnackbar(
                                                      txt:
                                                          'Copied to clipboard',
                                                      icon: Icons.copy_rounded);
                                                }
                                              });
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
                    child: SingleChildScrollView(
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
                              // box.get('email'),
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

                          customDrawerTile(
                            title: 'Preferences',
                            leading: Icons.settings,
                            onpressed: () {
                              Get.to(
                                () => PreferencesPage(),
                              );
                            },
                          ),
                          CustomDivider(),
                          // customDrawerTile(
                          //   title: 'Password Strength Checker',
                          //   leading: Icons.emoji_emotions,
                          //   onpressed: () async {
                          //     // Get.to(
                          //     //   () => PreferencesPage(),
                          //     // );
                          //     Future<Uint8List> readImageBytes(
                          //         String assetPath) async {
                          //       final data = await rootBundle.load(assetPath);
                          //       return data.buffer.asUint8List();
                          //     }

                          //     try {
                          //       final model = GenerativeModel(
                          //         model: 'gemini-1.0-pro-vision-latest',
                          //         apiKey:
                          //             'AIzaSyDTqizbF24ymCA-x2Im_njQ6ObtXdO1oAI',
                          //       );
                          //       // final password = '38DhwyD*/+#D4';
                          //       final prompt =
                          //           // 'Determine Strength of this password: $password. Strength should be in a single word and also rate this password from 0 to 10. give a color code in HEX format according to password stength and rating .if password is week or easy to crack than generate a stronger password';
                          //           '''list all food items with calories and quantity of each item you seeing in image.
                          //           quantity should be accurate accoring to the image
                          //           Every item should be listed as:
                          //           {item name,quantity in the image,calories in the quantity(that is in the image)}
                          //           ''';
                          //       print('Prompt: $prompt');

                          //       final content = [
                          //         // Content.text(prompt)
                          //         Content.multi([
                          //           TextPart(prompt),
                          //           // The only accepted mime types are image/*.
                          //           DataPart('image/jpeg',
                          //               await readImageBytes('assets/img.jpg')),
                          //           // DataPart(
                          //           //     'image/jpeg',
                          //           //     await readImageBytes(
                          //           //         'assets/privacy.jpg')),
                          //         ])
                          //       ];
                          //       // final tokenCount = await model.countTokens(content);
                          //       // print('Token count: ${tokenCount.totalTokens}');

                          //       final response =
                          //           await model.generateContent(content);
                          //       //  for (final response in responses) {
                          //       //   print(response.text);
                          //       //   stdout.write(response.text);
                          //       // }
                          //       // stdout.writeln();
                          //       print(response.text);
                          //       // final prompt = 'Generate a strong password';
                          //       // final content = [Content.text(prompt)];
                          //       // final response =
                          //       //     await model.generateContent(content);

                          //       // print(response.text);
                          //       print('process ended');
                          //     } catch (e) {
                          //       print(e);
                          //     }
                          //   },
                          // ),
                          // CustomDivider(),
                          customDrawerTile(
                            title: 'Check For Update',
                            leading: Icons.update_sharp,
                            onpressed: () {
                              if (_isShorebirdAvailable) {
                                _checkForUpdate(showSnackbar: true);
                              }
                              // ScaffoldMessenger.of(context)
                              //     .hideCurrentMaterialBanner();
                              // ScaffoldMessenger.of(context).showMaterialBanner(
                              //     customMaterialBanner(
                              //         title: 'Downloading... '));
                            },
                          ),
                          CustomDivider(),
                          // customDrawerTile(
                          //   title: 'Hide Gallery',
                          //   leading: Icons.browse_gallery,
                          //   onpressed: () async {
                          //     Get.to(
                          //       () => GalleryView(),
                          //     );

                          //   },
                          // ),
                          // CustomDivider(),
                          // customDrawerTile(
                          //   title: 'Enable Autofill',
                          //   leading: Icons.hdr_auto_outlined,
                          //   onpressed: () async {
                          //     Get.to(
                          //       () => AutofillPage(),
                          //     );
                          //   },
                          // ),
                          // CustomDivider(),

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
                              customAwesomeDialog(
                                details: 'Do you want to logout?',
                                okpress: () async {
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
                              );
                            },
                          )
                        ],
                      ),
                    ));
              }),
          // backgroundColor: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }

  MaterialBanner customMaterialBanner({
    required String title,
    List<Widget>? actions,
  }) {
    return MaterialBanner(
      content: CustomText(
        title: title,
        fontcolor: Colors.black,
        fontsize: 20,
      ),
      backgroundColor: Colors.white,
      dividerColor: Colors.black,
      actions: actions ??
          [
            SizedBox(
              height: 14,
              width: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            ),
          ],
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
