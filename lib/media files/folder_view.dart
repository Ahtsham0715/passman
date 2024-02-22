import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_filex/open_filex.dart';
import 'package:passman/constants.dart';
import 'package:passman/media%20files/controllers/media_controller.dart';
import 'package:passman/media%20files/custom_future_builder_widget.dart';
import 'package:passman/media%20files/gallery_view.dart';
import 'package:passman/media%20files/models/custom_popmenu_model.dart';
import 'package:passman/records/controllers/records_controller.dart';
import 'package:passman/records/create_new_record_page.dart';
import 'package:passman/records/models/password_model.dart';

import 'package:passman/res/components/full_image_view.dart';
import 'package:passman/res/components/loading_page.dart';
import 'package:encrypt/encrypt.dart' as encryption;
import '../records/record_details_page.dart';
import '../res/components/custom_snackbar.dart';
import '../res/components/custom_text.dart';
import '../res/components/master_password_dialog.dart';
import '../res/components/new_folder.dart';

class FolderView extends GetView<MediaController> {
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
    final RecordsController recordscontroller = RecordsController();
    // mediacontroller
    //     .foldersPasswordBox(this.folderKey)
    //     .listenable()
    //     .addListener(() {
    //   mediacontroller.update();
    // });

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
          GetBuilder<MediaController>(
              id: 'availableFilesCount',
              builder: (controller) {
                print('selectedFilesCount build...');
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    folderType == 'Passwords'
                        ? controller.box.length.toString()
                        : controller.pickedfiles.length.toString(),
                    style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'majalla'),
                  ),
                );
              }),
          CustomPopMenuButton(children: [
            CustomPopMenuItemModel(
                title: "Edit",
                onSelected: () {
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
                }),
            CustomPopMenuItemModel(
                title: "Delete",
                onSelected: () {
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
                })
          ]),
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
          if (folderType == 'Passwords') {
            Get.to(
              () => CreateRecord(
                folderKey: this.folderKey,
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
          } else {
            Get.to(() => GalleryView(
                  folderKey: this.folderKey,
                ));
          }
          // showModalBottomSheet(
          //   context: context,
          //   enableDrag: true,
          //   isScrollControlled: true,
          //   builder: (context) {
          //     return SafeArea(child: GalleryView());
          //   },
          // );
          // FilePickerResult? result = await FilePicker.platform.pickFiles(
          //   allowMultiple: true,
          //   type: folderType == 'Images'
          //       ? FileType.image
          //       : folderType == 'Videos'
          //           ? FileType.video
          //           : FileType.any,
          // );
          // if (result != null) {
          //   await mediacontroller
          //       .uploadFiles(result: result, folderKey: this.folderKey)
          //       .then((value) {});

          //   // print(foldersdatabox.get(folderKey));
          // }
        },
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: bodyGradient(context),
        ),
        child: FutureBuilderGridView(
          gridCount: 7,
          future: this.folderType == 'Passwords'
              ? controller.getPasswords(folderKey)
              : controller.getData(folderKey),
          itemBuilder: GetBuilder<MediaController>(
              // assignId: true,
              // id: 'folder_view_builder',
              // init: MediaController(),
              builder: (controller) {
            // print(foldersdatabox.get(folderKey));
            // print('view updated');
            return (folderType == 'Passwords'
                    ? controller.box.isEmpty
                    : controller.pickedfiles.isEmpty)
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
                : folderType == 'Passwords'
                    ? ListView.builder(
                        itemCount: controller.box.length,
                        itemBuilder: (context, index) {
                          dynamic data;

                          data = controller.box[index];
                          return ListTile(
                            // onLongPress: () {},
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
                                                    logininfo.get('password')),
                                                iv: iv)) {
                                          Get.to(
                                            () => RecordDetails(
                                              folderKey: this.folderKey,
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
                                              txt: 'Incorrect master password',
                                              icon: Icons.error_outlined);
                                        }
                                      }
                                    })
                                  : await recordscontroller
                                      .authenticateWithBiometrics()
                                      .then((value) async {
                                      if (recordscontroller
                                          .isauthenticated.value) {
                                        Get.to(
                                          () => RecordDetails(
                                            folderKey: this.folderKey,
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
                            leading: websites.containsKey(
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
                                title: data['value'].title.toString(),
                                fontcolor: Colors.white,
                                fontweight: FontWeight.w500,
                                fontsize: 23.0),
                            subtitle: CustomText(
                                title: encrypter.decrypt(
                                    encryption.Encrypted.from64(
                                        data['value'].login.toString()),
                                    iv: iv),
                                fontcolor: Colors.white,
                                fontweight: FontWeight.w500,
                                fontsize: 20.0),
                            trailing: InkWell(
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
                                            await Clipboard.setData(
                                                ClipboardData(
                                              text: encrypter.decrypt(
                                                  encryption.Encrypted.from64(
                                                      data['value']
                                                          .password
                                                          .toString()),
                                                  iv: iv),
                                            ));
                                            styledsnackbar(
                                                txt: 'Copied to clipboard',
                                                icon: Icons.copy_rounded);
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
                                          await Clipboard.setData(ClipboardData(
                                            text: encrypter.decrypt(
                                                encryption.Encrypted.from64(
                                                    data['value']
                                                        .password
                                                        .toString()),
                                                iv: iv),
                                          ));
                                          styledsnackbar(
                                              txt: 'Copied to clipboard',
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
                      )
                    : GridView.builder(
                        itemCount: controller.pickedfiles.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          // final folder = controller.availableFolders[index];
                          // final isSelected = controller.selectedAssets.contains(folder);
                          print('building... ');
                          return InkWell(
                            onTap: !controller.isImage(controller
                                    .pickedfiles[index]['type']
                                    .toString()
                                    .toLowerCase())
                                ? () async {
                                    OpenFilex.open(
                                        controller.pickedfiles[index]['data']);
                                  }
                                : () {
                                    Get.to(
                                      () => FullScreenImagePage(
                                        imageUrl: controller.decryptFile(
                                            controller.pickedfiles[index]
                                                ['data']),
                                        memoryImage: true,
                                      ),
                                    );
                                  },
                            child: Container(
                              width: 200,
                              height: 250,
                              margin: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: controller.isImage(controller
                                        .pickedfiles[index]['type']
                                        .toString()
                                        .toLowerCase())
                                    ? DecorationImage(
                                        image: MemoryImage(
                                          controller.decryptFile(controller
                                              .pickedfiles[index]['data']),
                                        ),
                                        // AssetEntityImageProvider(
                                        //   controller
                                        //       .foldersThumbnail[folder.id.toString()],
                                        //   isOriginal: true,
                                        // ),

                                        fit: BoxFit.fill)
                                    : null,
                                color: Colors.black45,
                              ),
                              child:
                                  !controller.isImage(controller
                                          .pickedfiles[index]['type']
                                          .toString()
                                          .toLowerCase())
                                      ? Column(
                                          // mainAxisSize: MainAxisSize.max,
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // SizedBox(
                                            //   height: 40,
                                            // ),
                                            Expanded(
                                              flex: 4,
                                              child: Center(
                                                child: Icon(
                                                  mediacontroller
                                                      .fileIconDecider(
                                                          controller
                                                                  .pickedfiles[
                                                              index]['type']),
                                                  color: Colors.white,
                                                  size: 35,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              // alignment: Alignment.bottomCenter,
                                              // backgroundColor: Colors.white,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    flex: 6,
                                                    child: Text(
                                                      '${controller.pickedfiles[index]['name']}',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'majalla'),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: CustomPopMenuButton(
                                                        children: [
                                                          CustomPopMenuItemModel(
                                                              title:
                                                                  'Export To Phone',
                                                              onSelected:
                                                                  () async {
                                                                controller.ExportFile(
                                                                    controller.decryptFile(
                                                                        controller.pickedfiles[index]
                                                                            [
                                                                            'data']),
                                                                    controller.pickedfiles[
                                                                            index]
                                                                        [
                                                                        'absolutePath'],
                                                                    folderKey,
                                                                    controller
                                                                            .pickedfiles[
                                                                        index]);
                                                              }),
                                                          CustomPopMenuItemModel(
                                                              title: 'Delete',
                                                              onSelected: () {
                                                                AwesomeDialog(
                                                                  context:
                                                                      context,
                                                                  animType: AnimType
                                                                      .topSlide,
                                                                  dialogType:
                                                                      DialogType
                                                                          .question,
                                                                  title:
                                                                      'Are you sure?',
                                                                  desc:
                                                                      'Do you want to delete this image?',
                                                                  btnOkOnPress:
                                                                      () async {
                                                                    // Get.dialog(LoadingPage());
                                                                    try {
                                                                      mediacontroller
                                                                              .pickedfiles =
                                                                          foldersdatabox
                                                                              .get(folderKey);
                                                                      mediacontroller
                                                                          .pickedfiles
                                                                          .remove(
                                                                              controller.pickedfiles[index]);
                                                                      foldersdatabox.put(
                                                                          folderKey,
                                                                          mediacontroller
                                                                              .pickedfiles);
                                                                      mediacontroller
                                                                              .pickedfiles =
                                                                          foldersdatabox
                                                                              .get(folderKey);

                                                                      // Get.back();
                                                                      // Get.back();
                                                                      styledsnackbar(
                                                                          txt:
                                                                              'Deleted Successfully.',
                                                                          icon:
                                                                              Icons.check);
                                                                      // controller.update();
                                                                    } catch (e) {
                                                                      // Get.back();
                                                                      styledsnackbar(
                                                                          txt:
                                                                              'Error occured.$e',
                                                                          icon:
                                                                              Icons.error);
                                                                    }
                                                                  },
                                                                  btnCancelOnPress:
                                                                      () {
                                                                    // Get.back();
                                                                  },
                                                                )..show();
                                                              }),
                                                        ]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: 200,
                                              height: 45,
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.blueGrey,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10.0),
                                                  bottomRight:
                                                      Radius.circular(10.0),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    flex: 6,
                                                    child: Text(
                                                      '${controller.pickedfiles[index]['name']}',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'majalla'),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: CustomPopMenuButton(
                                                        children: [
                                                          CustomPopMenuItemModel(
                                                              title:
                                                                  'Export To Phone',
                                                              onSelected:
                                                                  () async {
                                                                controller.ExportFile(
                                                                    controller.decryptFile(
                                                                        controller.pickedfiles[index]
                                                                            [
                                                                            'data']),
                                                                    controller.pickedfiles[
                                                                            index]
                                                                        [
                                                                        'absolutePath'],
                                                                    folderKey,
                                                                    controller
                                                                            .pickedfiles[
                                                                        index]);
                                                              }),
                                                          CustomPopMenuItemModel(
                                                              title: 'Delete',
                                                              onSelected: () {
                                                                AwesomeDialog(
                                                                  context:
                                                                      context,
                                                                  animType: AnimType
                                                                      .topSlide,
                                                                  dialogType:
                                                                      DialogType
                                                                          .question,
                                                                  title:
                                                                      'Are you sure?',
                                                                  desc:
                                                                      'Do you want to delete this file?',
                                                                  btnOkOnPress:
                                                                      () async {
                                                                    // Get.dialog(LoadingPage());
                                                                    try {
                                                                      mediacontroller
                                                                              .pickedfiles =
                                                                          foldersdatabox
                                                                              .get(folderKey);
                                                                      mediacontroller
                                                                          .pickedfiles
                                                                          .remove(
                                                                              controller.pickedfiles[index]);
                                                                      foldersdatabox.put(
                                                                          folderKey,
                                                                          mediacontroller
                                                                              .pickedfiles);
                                                                      mediacontroller
                                                                              .pickedfiles =
                                                                          foldersdatabox
                                                                              .get(folderKey);

                                                                      // Get.back();
                                                                      // Get.back();
                                                                      styledsnackbar(
                                                                          txt:
                                                                              'Deleted Successfully.',
                                                                          icon:
                                                                              Icons.check);
                                                                      controller
                                                                          .update([
                                                                        'availableFilesCount'
                                                                      ]);
                                                                      // controller.update();
                                                                    } catch (e) {
                                                                      // Get.back();
                                                                      styledsnackbar(
                                                                          txt:
                                                                              'Error occured.$e',
                                                                          icon:
                                                                              Icons.error);
                                                                    }
                                                                  },
                                                                  btnCancelOnPress:
                                                                      () {
                                                                    // Get.back();
                                                                  },
                                                                )..show();
                                                              }),
                                                        ]),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                            ),
                          );
                        },
                      );
          }),
        ),
      ),
    );
  }
}

//  Positioned(
//                               top: 10,
//                               right: 10,
//                               child: CustomPopMenuButton(children: [
//                                 CustomPopMenuItemModel(
//                                     title: 'Export To Phone',
//                                     onSelected: () async {
//                                       controller.ExportFile(
//                                           controller.decryptFile(controller
//                                               .pickedfiles[index]['data']),
//                                           controller.pickedfiles[index]
//                                               ['absolutePath'],
//                                           folderKey,
//                                           controller.pickedfiles[index]);
//                                     }),
//                                 CustomPopMenuItemModel(
//                                     title: 'Delete',
//                                     onSelected: () {
//                                       AwesomeDialog(
//                                         context: context,
//                                         animType: AnimType.topSlide,
//                                         dialogType: DialogType.question,
//                                         title: 'Are you sure?',
//                                         desc:
//                                             'Do you want to delete this image?',
//                                         btnOkOnPress: () async {
//                                           // Get.dialog(LoadingPage());
//                                           try {
//                                             mediacontroller.pickedfiles =
//                                                 foldersdatabox.get(folderKey);
//                                             mediacontroller.pickedfiles.remove(
//                                                 controller.pickedfiles[index]);
//                                             foldersdatabox.put(folderKey,
//                                                 mediacontroller.pickedfiles);
//                                             mediacontroller.pickedfiles =
//                                                 foldersdatabox.get(folderKey);

//                                             // Get.back();
//                                             // Get.back();
//                                             styledsnackbar(
//                                                 txt: 'Deleted Successfully.',
//                                                 icon: Icons.check);
//                                             // controller.update();
//                                           } catch (e) {
//                                             // Get.back();
//                                             styledsnackbar(
//                                                 txt: 'Error occured.$e',
//                                                 icon: Icons.error);
//                                           }
//                                         },
//                                         btnCancelOnPress: () {
//                                           // Get.back();
//                                         },
//                                       )..show();
//                                     }),
//                               ])
//                               // InkWell(
//                               //   onTap: () {

//                               //   },
//                               //   child: CircleAvatar(
//                               //     radius: 20.0,
//                               //     backgroundColor: Colors.black45,
//                               //     child: Icon(
//                               //       MdiIcons.deleteForever,
//                               //       color: Colors.white,
//                               //       size: 25.0,
//                               //     ),
//                               //   ),
//                               // ),
//                               ),

class CustomPopMenuButton extends StatelessWidget {
  final List<CustomPopMenuItemModel> children;
  const CustomPopMenuButton({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      iconColor: Colors.white,
      shadowColor: Colors.black,
      itemBuilder: (_) {
        return List.generate(
          children.length,
          (index) => PopupMenuItem<String>(
            value: children[index].title,
            child: Text(
              children[index].title,
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: children[index].onSelected,
          ),
        );
      },
      icon: const Icon(Icons.more_vert_rounded),
      // onSelected: (i) {

      // },
    );
  }
}
