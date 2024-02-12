import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_filex/open_filex.dart';
import 'package:passman/constants.dart';
import 'package:passman/media%20files/controllers/media_controller.dart';
import 'package:passman/res/components/full_image_view.dart';
import 'package:passman/res/components/loading_page.dart';
import '../res/components/custom_snackbar.dart';
import '../res/components/custom_text.dart';
import '../res/components/new_folder.dart';

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
            gradient: appBarGradient(context),
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
            onSelected: (i) {
              if (i == "1") {
                showDialog(
                  context: context,
                  builder: (context) => showNewFolderDialog(
                    name: folderName.toString(),
                    type: folderType,
                    isEdit: true,
                  ),
                ).then((value) {
                  if (value != null) {
                    print(value);
                    Get.dialog(LoadingPage());
                    try {
                      foldersbox.put(folderKey, {
                        'name': value['name'].toString(),
                        'type': value['type'].toString(),
                      });

                      Get.back();
                      Get.back();
                    } catch (e) {
                      Get.back();
                      Get.back();
                      styledsnackbar(
                          txt: 'Error occured. $e', icon: Icons.error);
                    }
                  }
                });
              } else if (i == "2") {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.topSlide,
                  dialogType: DialogType.question,
                  title: 'Are you sure?',
                  desc: 'Do you want to delete this folder?',
                  btnOkOnPress: () async {
                    try {
                      foldersdatabox.delete(folderKey);
                      foldersbox.delete(folderKey);
                      Get.back();
                      styledsnackbar(
                          txt: 'Folder Deleted Successfully',
                          icon: Icons.delete);
                    } catch (e) {
                      styledsnackbar(
                          txt: 'Error occured. $e', icon: Icons.error);
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        label: CustomText(
          title: 'Add',
          fontcolor: Colors.white,
          fontsize: 25.0,
          fontweight: FontWeight.w500,
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
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
            await mediacontroller
                .uploadFiles(result: result, folderKey: this.folderKey)
                .then((value) {});

            // print(foldersdatabox.get(folderKey));
          }
        },
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: bodyGradient(context),
        ),
        child: GetBuilder<MediaController>(
            // assignId: true,
            // id: 'folder_view_builder',
            init: MediaController(),
            builder: (controller) {
              if (foldersdatabox.containsKey(folderKey)) {
                controller.pickedfiles = foldersdatabox.get(folderKey);
              } else {
                controller.pickedfiles = [];
              }
              print(foldersdatabox.get(folderKey));
              // print('view updated');
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
                      itemCount: controller.pickedfiles.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        // final folder = controller.availableFolders[index];
                        // final isSelected = controller.selectedAssets.contains(folder);
                        print('building... ');
                        return Stack(
                          children: [
                            InkWell(
                              onTap: !(controller.pickedfiles[index]['type'] ==
                                          'jpg' ||
                                      controller.pickedfiles[index]['type'] ==
                                          'png' ||
                                      controller.pickedfiles[index]['type'] ==
                                          'jpeg')
                                  ? () async {
                                      // var data = controller.decodeImageFromBase64(
                                      //     controller.pickedfiles[index]['data']);
                                      // final buffer = data.buffer;
                                      // Directory tempDir =
                                      //     await getTemporaryDirectory();
                                      // String tempPath = tempDir.path;
                                      // File file = File(
                                      //     '$tempPath/tempfile.${controller.pickedfiles[index]['type']}');
                                      // await file
                                      //     .writeAsBytes(buffer.asUint8List(
                                      //         data.offsetInBytes,
                                      //         data.lengthInBytes))
                                      //     .then((value) async {
                                      //   OpenFilex.open(
                                      //       '$tempPath/tempfile.${controller.pickedfiles[index]['type']}');
                                      // });
                                      OpenFilex.open(controller
                                          .pickedfiles[index]['data']);
                                    }
                                  : () {
                                      Get.to(
                                        () => FullScreenImagePage(
                                          imageUrl: controller
                                              .pickedfiles[index]['data'],
                                        ),
                                      );
                                    },
                              child: Container(
                                width: 200,
                                height: 200,
                                margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: (controller.pickedfiles[index]
                                                  ['type'] ==
                                              'jpg' ||
                                          controller.pickedfiles[index]
                                                  ['type'] ==
                                              'png' ||
                                          controller.pickedfiles[index]
                                                  ['type'] ==
                                              'jpeg')
                                      ? DecorationImage(
                                          image: FileImage(File(controller
                                              .pickedfiles[index]['data'])),
                                          // AssetEntityImageProvider(
                                          //   controller
                                          //       .foldersThumbnail[folder.id.toString()],
                                          //   isOriginal: true,
                                          // ),

                                          fit: BoxFit.fill)
                                      : null,
                                  color: Colors.blueGrey,
                                ),
                                child: !(controller.pickedfiles[index]
                                                ['type'] ==
                                            'jpg' ||
                                        controller.pickedfiles[index]['type'] ==
                                            'png' ||
                                        controller.pickedfiles[index]['type'] ==
                                            'jpeg')
                                    ? Center(
                                        // backgroundColor: Colors.white,
                                        child: Text(
                                          '${controller.pickedfiles[index]['name']}',
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontFamily: 'majalla'),
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 200,
                                            decoration: BoxDecoration(
                                              color: Colors.blueGrey,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Text(
                                              '${controller.pickedfiles[index]['name']}',
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                  fontFamily: 'majalla'),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 15,
                              child: InkWell(
                                onTap: () {
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.topSlide,
                                    dialogType: DialogType.question,
                                    title: 'Are you sure?',
                                    desc: 'Do you want to delete this image?',
                                    btnOkOnPress: () async {
                                      // Get.dialog(LoadingPage());
                                      try {
                                        mediacontroller.pickedfiles =
                                            foldersdatabox.get(folderKey);
                                        mediacontroller.pickedfiles.remove(
                                            controller.pickedfiles[index]);
                                        foldersdatabox.put(folderKey,
                                            mediacontroller.pickedfiles);
                                        mediacontroller.pickedfiles =
                                            foldersdatabox.get(folderKey);

                                        // Get.back();
                                        // Get.back();
                                        styledsnackbar(
                                            txt: 'Deleted Successfully.',
                                            icon: Icons.check);
                                        // controller.update();
                                      } catch (e) {
                                        // Get.back();
                                        styledsnackbar(
                                            txt: 'Error occured.$e',
                                            icon: Icons.error);
                                      }
                                    },
                                    btnCancelOnPress: () {
                                      // Get.back();
                                    },
                                  )..show();
                                },
                                child: CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: appDarkColor,
                                  child: Icon(
                                    MdiIcons.deleteForever,
                                    color: Colors.white,
                                    size: 25.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
            }),
      ),
    );
  }
}
