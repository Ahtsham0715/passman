import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/constants.dart';
import 'package:passman/records/records_page.dart';

class AskBioAuth extends StatefulWidget {
  const AskBioAuth({Key? key}) : super(key: key);

  @override
  _AskBioAuthState createState() => _AskBioAuthState();
}

class _AskBioAuthState extends State<AskBioAuth> {
  bool allowauth = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
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
            TextButton(
              onPressed: () {
                logininfo.put('bio_auth', false);
                Get.to(
                  () => const PasswordsPage(),
                );
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white, //Color(0XFFd66d75),
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: bodyGradient(context),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Allow Fingerprint Login From Next time',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: height * 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: width * 0.45,
                    child: MaterialButton(
                      onPressed: () {
                        logininfo.put('bio_auth', false);
                        Get.to(
                          () => const PasswordsPage(),
                        );
                      },
                      color: Colors.grey,
                      minWidth: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.05,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        'Decline',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.45,
                    child: MaterialButton(
                      onPressed: () {
                        logininfo.put('bio_auth', true);
                        Get.to(
                          () => const PasswordsPage(),
                        );
                      },
                      color: Colors.white, //Color(0XFFd66d75),
                      minWidth: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.05,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        'Allow',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(
                              0XFFd66d75), //Color(0XFFd66d75)Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
