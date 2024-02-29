import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/constants.dart';
import 'package:passman/records/controllers/records_controller.dart';
import 'package:passman/records/controllers/settings_controller.dart';
import 'package:passman/records/records_page.dart';
import 'package:passman/res/components/awesome_custom_dialog.dart';
import 'package:passman/res/components/custom_snackbar.dart';
import 'package:passman/res/components/custom_text.dart';
import 'package:screen_protector/screen_protector.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

//   @override
//   State<PreferencesPage> createState() => _PreferencesPageState();
// }

// class _PreferencesPageState extends State<PreferencesPage> {

  @override
  Widget build(BuildContext context) {
    final RecordsController recordscontroller = Get.put(RecordsController());
    final SettingsController settingscontroller = Get.put(SettingsController());
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        // backgroundColor: Colors.green,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          'Preferences',
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
              begin: MediaQuery.of(context).orientation == Orientation.portrait
                  ? Alignment.bottomCenter
                  : Alignment.bottomLeft,
              end: MediaQuery.of(context).orientation == Orientation.portrait
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
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
            customDrawerTile(
              title: 'Backup Passwords',
              leading: Icons.backup,
              onpressed: () async {
                customAwesomeDialog(
                  title: 'Do you want to backup all saved passwords?',
                  details: 'Backup will store in our cloud database',
                  okpress: () {
                    recordscontroller.backupPasswordsToCloud();
                  },
                );
                // recordscontroller.backupPasswordsToCloud();
              },
            ),
            CustomDivider(),
            customDrawerTile(
              title: 'Restore Backup',
              leading: Icons.settings_backup_restore_sharp,
              onpressed: () async {
                customAwesomeDialog(
                  // title:
                  //     'Do you want to take backup of all saved passwords?',
                  details: 'Do you want to restore backup from cloud?',
                  okpress: () {
                    recordscontroller.importPasswordsFromCloud();
                  },
                );
                // recordscontroller.backupPasswordsToCloud();
              },
            ),
            CustomDivider(),
            if (logininfo.get('is_biometric_available'))
              GetBuilder<SettingsController>(builder: (controller) {
                return SwitchListTile(
                  value: settingscontroller.bioauth,
                  inactiveTrackColor: Color.fromARGB(255, 228, 151, 157),
                  activeColor: Colors.green,
                  title: CustomText(
                      fontcolor: Colors.white,
                      title: 'Use Fingerprint',
                      fontweight: FontWeight.w500,
                      fontsize: 22.0),
                  onChanged: (value) {
                    // print(
                    //     'bio ${logininfo.get('is_biometric_available')}');
                    logininfo.put('bio_auth', value);

                    print(logininfo.get('bio_auth'));
                    // setState(() {
                    settingscontroller.bioauth = value;
                    settingscontroller.update();
                    // });
                    if (value) {
                      styledsnackbar(
                          txt: 'You can now use fingerprint authentication',
                          icon: Icons.login);
                    }
                  },
                );
              }),
            CustomDivider(),
            GetBuilder<SettingsController>(builder: (controller) {
              return SwitchListTile(
                value: settingscontroller.allowScreenshots,
                inactiveTrackColor: Color.fromARGB(255, 228, 151, 157),
                activeColor: Colors.green,
                title: CustomText(
                    fontcolor: Colors.white,
                    title: 'Allow Screenshots',
                    fontweight: FontWeight.w500,
                    fontsize: 22.0),
                onChanged: (value) async {
                  // print(
                  //     'bio ${logininfo.get('is_biometric_available')}');
                  logininfo.put('allowScreenshot', value);

                  print(logininfo.get('allowScreenshot'));
                  // setState(() {
                  settingscontroller.allowScreenshots = value;
                  settingscontroller.update();
                  // });
                  if (value) {
                    await ScreenProtector.preventScreenshotOff();
                    styledsnackbar(
                        txt: 'Screenshots are allowed in this app now',
                        icon: Icons.screenshot);
                  } else {
                    await ScreenProtector.preventScreenshotOn();
                    styledsnackbar(
                        txt: 'Screenshots are prevented in this app now',
                        icon: Icons.screenshot);
                  }
                },
              );
            }),
            CustomDivider(),
          ],
        ),
      ),
    );
  }
}
