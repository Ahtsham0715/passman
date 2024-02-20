import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/media%20files/controllers/gallery_controller.dart';
import 'package:passman/media%20files/controllers/media_controller.dart';
import 'package:passman/media%20files/custom_future_builder_widget.dart';
import 'package:passman/res/components/custom_snackbar.dart';
import 'package:passman/res/components/full_image_view.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../constants.dart';

class FolderAssetsPage extends StatelessWidget {
  final AssetPathEntity folder;
  final String folderKey;
  FolderAssetsPage({required this.folder, required this.folderKey});

//   @override
//   State<FolderAssetsPage> createState() => _FolderAssetsPageState();
// }

// class _FolderAssetsPageState extends State<FolderAssetsPage> {
//   final GalleryController cont = Get.find();
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         cont.getFilesUsingPathManager(widget.folder).then((value) {
//           cont.isLoadingFiles = false;
//           cont.update(['FilesView', true]);
//         });
//       }
//     });

//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    final GalleryController cont = Get.find();
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        // backgroundColor: Colors.green,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          folder.name,
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
          GetBuilder<GalleryController>(
              id: 'selectedFilesCount',
              builder: (controller) {
                print('selectedFilesCount build...');
                return controller.selectedFiles.isEmpty
                    ? Center()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          controller.selectedFiles.length.toString(),
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: 'majalla'),
                        ),
                      );
              }),
          GetBuilder<GalleryController>(
              id: 'showCheckButton',
              builder: (controller) {
                print('showCheckButton build...');
                return controller.selectedFiles.isEmpty
                    ? Center()
                    : IconButton(
                        onPressed: () {
                          if (cont.selectedFiles.isEmpty) {
                            styledsnackbar(
                                txt: 'No Image Selected', icon: Icons.warning);
                          } else {
                            String folderKey = this.folderKey;
                            MediaController mediaController = Get.find();

                            Get.back();
                            Get.back();
                            mediaController.uploadFileToVault(
                                folderKey: folderKey,
                                selectedFiles: cont.selectedFiles);
                          }
                        },
                        icon: Icon(Icons.check),
                      );
              }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        // height: height,
        // width: width,
        decoration: BoxDecoration(
          gradient: bodyGradient(context),
        ),
        child: FutureBuilderGridView(
          gridCount: 8,
          future: cont.getFilesUsingPathManager(folder),
          itemBuilder: GetBuilder<GalleryController>(
              assignId: true,
              id: 'FilesView',
              autoRemove: false,
              builder: (controller) {
                return GridView.builder(
                  itemCount: controller.isLoadingFiles
                      ? controller.dummyAvailableFiles.length
                      : controller.availableFiles.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    final file = controller.isLoadingFiles
                        ? controller.dummyAvailableFiles[index]
                        : controller.availableFiles[index];
                    print('building file view... ');
                    print(file['path']);
                    // final isSelected = controller.selectedFiles.contains(file);
                    return GestureDetector(
                      // onTap: () async {
                      //   //  var afile =  await asset.file;
                      //   //  var bytes = await afile!.readAsBytes();
                      //   //  log(bytes.toString());
                      //   // controller.toggleFileSelection(file);
                      // },
                      onTap: controller.isLoadingFiles
                          ? null
                          : () {
                              // Get.back();
                              // Get.back();
                              controller.toggleFileSelection(file['file']);
                              // print(controller.selectedFiles);
                              // Get.to(() => FullScreenImagePage(
                              //       imageUrl: file['path'],
                              //     ));
                            },
                      onLongPress: () {
                        Get.to(() => FullScreenImagePage(
                              imageUrl: file['path'],
                            ));
                        // customAwesomeDialog(
                        //     details: 'Do you want to delete this image?',
                        //     okpress: () {
                        //       controller.deleteFile(file['path']);
                        //     });
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(5.0),
                            width: 200,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey.shade400,
                              image: controller.isLoadingFiles
                                  ? null
                                  : DecorationImage(
                                      image: FileImage(
                                        File(file['path']),
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                            ),
                            // child: Image(
                            //   image: AssetEntityImageProvider(asset, isOriginal: true, ),
                            //   fit: BoxFit.fill,
                            // ),
                          ),
                          if (controller.isLoading == false)
                            GetBuilder<GalleryController>(
                              id: 'selectedIcon',
                              builder: (cont) {
                                print('selectedIcon build...');
                                return controller.selectedFiles
                                        .contains(file['file'])
                                    ? Positioned(
                                        top: 10,
                                        right: 10,
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.black,
                                          size: 30.0,
                                        ),
                                      )
                                    : Center();
                              },
                            )
                        ],
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
