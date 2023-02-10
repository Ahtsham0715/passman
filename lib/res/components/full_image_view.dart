import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/res/components/custom_snackbar.dart';
import 'package:passman/res/components/loading_page.dart';

import '../../constants.dart';
import '../../media files/controllers/media_controller.dart';

class FullScreenImagePage extends StatelessWidget {
  final imageUrl;
  final String encodedimg;
  final String folderKey;
  const FullScreenImagePage(
      {required this.imageUrl,
      required this.encodedimg,
      required this.folderKey});

  @override
  Widget build(BuildContext context) {
    final MediaController mediacontroller = MediaController();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
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
                ),
                image: DecorationImage(
                  image: MemoryImage(imageUrl),
                  // fit: BoxFit.fill,
                ),
              ),
            ),
            ListTile(
              trailing: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
              leading: InkWell(
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.topSlide,
                    dialogType: DialogType.question,
                    title: 'Are you sure?',
                    desc: 'Do you want to delete this image?',
                    btnOkOnPress: () async {
                      Get.dialog(LoadingPage());
                      try {
                        mediacontroller.pickedfiles =
                            foldersdatabox.get(folderKey);
                        mediacontroller.pickedfiles.remove(encodedimg);
                        foldersdatabox.put(
                            folderKey, mediacontroller.pickedfiles);

                        Get.back();
                        Get.back();
                        styledsnackbar(
                            txt: 'Image Deleted Successfully.',
                            icon: Icons.check);
                      } catch (e) {
                        Get.back();
                        styledsnackbar(
                            txt: 'Error occured.$e', icon: Icons.error);
                      }
                    },
                    btnCancelOnPress: () {
                      // Get.back();
                    },
                  )..show();
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
