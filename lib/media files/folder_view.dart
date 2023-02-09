import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:passman/constants.dart';
import 'package:passman/media%20files/controllers/media_controller.dart';
import 'package:passman/res/components/file_picker.dart';
import 'package:passman/res/components/full_image_view.dart';

import '../res/components/custom_text.dart';

class FolderView extends StatelessWidget {
  final String folderName;
  final String folderKey;
  final String folderType;
  const FolderView(
      {Key? key,
      required this.folderName,
      required this.folderKey,
      required this.folderType});
  @override
  Widget build(BuildContext context) {
    final MediaController mediacontroller = MediaController();
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        // backgroundColor: Colors.green,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          folderName.toString(),
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
        label: CustomText(
          title: 'Add',
          fontcolor: Colors.white,
          fontsize: 25.0,
          fontweight: FontWeight.w500,
        ),
        icon: Icon(Icons.add),
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: folderType == 'Images'
                ? FileType.image
                : folderType == 'Videos'
                    ? FileType.video
                    : FileType.any,
          );
          if (result != null) {
            if (foldersdatabox.containsKey(folderKey)) {
              mediacontroller.pickedfiles = foldersdatabox.get(folderKey);
            } else {
              mediacontroller.pickedfiles = [];
            }

            result.files.forEach((file) async {
              await mediacontroller
                  .readFileAsBytes(file.path!)
                  .then((val) async {
                // print(value);
                await mediacontroller.encodeImageToBase64(val).then((value) {
                  mediacontroller.pickedfiles.add(value);
                  // print(value);
                });
              });
            });
            foldersdatabox.put(folderKey, mediacontroller.pickedfiles);
            // print(foldersdatabox.get(folderKey));
          }
        },
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0XFFd66d75),
              Color(0XFFe29587),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GetBuilder<MediaController>(
            assignId: true,
            id: 'folder_view_builder',
            init: MediaController(),
            builder: (controller) {
              if (foldersdatabox.containsKey(folderKey)) {
                controller.pickedfiles = foldersdatabox.get(folderKey);
              } else {
                controller.pickedfiles = [];
              }
              return controller.pickedfiles.isEmpty
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
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: controller.pickedfiles.length,
                      itemBuilder: (context, index) {
                        // var file;

                        //     .then((value) {
                        //   print(value);
                        //   file = value;
                        // });
                        return InkWell(
                          onTap: () {
                            Get.to(
                              () => FullScreenImagePage(
                                  imageUrl: controller.decodeImageFromBase64(
                                      controller.pickedfiles[index])),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: MemoryImage(
                                  controller.decodeImageFromBase64(
                                      controller.pickedfiles[index]),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    );
            }),
      ),
    );
  }
}
