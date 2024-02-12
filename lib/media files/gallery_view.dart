import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/constants.dart';
import 'package:passman/res/components/folder_assets_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:photo_manager/photo_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'controllers/gallery_controller.dart';

class GalleryView extends GetView<GalleryController> {
  @override
  Widget build(BuildContext context) {
   Get.put(GalleryController());
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        // backgroundColor: Colors.green,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Gallery Folders',
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
            builder: (cont) {
              return 
              
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: 
                cont.isHidingDirectories ?
                CircularProgressIndicator():
                GestureDetector(
                  onTap: () {
                    cont.isHidingDirectories = true;
                    cont.update();
                    cont.selectedAssets.forEach((asset) async {
                      FileSystemEntity thisAsset = asset['folder'];

                      Directory source = await Directory(thisAsset.path);
                      Directory myAppDir = await getApplicationDocumentsDirectory();
                      // // thisAsset.rename(myAppDir.path + '/' + thisAsset.path.split('/').last);
                      // Directory destinationDir = Directory(
                      //     myAppDir.path + '/' + thisAsset.path.split('/').last);
                      // await for (var entity in source.list()) {
                      //   if (entity is Directory) {
                      //     await cont.copyDirectory(
                      //         Directory(destinationDir.path));

                      //   } else if (entity is File) {
                      //     await entity.copy(destinationDir.path);
                      //     source.delete();
                      //   }
                      // }
                      var storageStatus = await Permission.storage.status;
                      var externalStorageStatus = await Permission.manageExternalStorage.status;
                      var cameraStatus = await Permission.camera.status;
                      await Permission.camera.request();
                      print(storageStatus);
                      print(externalStorageStatus);
                      print(cameraStatus);
                      // cont.createNoMediaFile(source.path );
                    });
                    // print('task completed');
                    cont.isHidingDirectories = false;
                    cont.update();
                  },
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 28.0,
                  ),
                ),
              );
            }
          ),
        ],
      ),
      body: GetBuilder<GalleryController>(
          assignId: true,
          id: 'GalleryView',
          autoRemove: false,
          builder: (cont) {
            return Container(
              padding: EdgeInsets.all(5.0),
              // height: height,
              // width: width,
              decoration: BoxDecoration(
                gradient: bodyGradient(context),
              ),
              child: GridView.builder(
                // shrinkWrap: true,
                itemCount: controller.isLoading
                    ? controller.dummyAvailableFolders.length
                    : controller.availableFolders.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  final folder = controller.isLoading
                      ? controller.dummyAvailableFolders[index]
                      : controller.availableFolders[index];
                  // final isSelected = controller.selectedAssets.contains(folder);
                  print('building... ');
                  return InkWell(
                    onLongPress: () {
                      Get.to(() => FolderAssetsPage(folder: folder['folder']));
                      // Handle folder selection
                    },
                    onTap: () {
                      print('toggle');
                      controller.toggleAssetSelection(folder);
                    },
                    child: Stack(
                      children: [
                        Skeletonizer(
                          enabled: controller.isLoading,
                          justifyMultiLineText: true,
                          //  textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(0.8),
                          effect: ShimmerEffect(
                            baseColor: appDarkColor.withOpacity(0.75),
                            highlightColor: appLightColor.withOpacity(0.75),
                          ),
                          child: Container(
                            width: 200,
                            height: 200,
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: controller.isLoading
                                  ? null
                                  : DecorationImage(
                                      image:
                                          FileImage(File(folder['thumbnail'])),
                                      // AssetEntityImageProvider(
                                      //   controller
                                      //       .foldersThumbnail[folder.id.toString()],
                                      //   isOriginal: true,
                                      // ),

                                      fit: BoxFit.fill),
                              color: controller.isLoading
                                  ? Colors.grey.shade500
                                  : Colors.blueGrey,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 200,
                                  padding: !controller.isLoading
                                      ? null
                                      : EdgeInsets.only(bottom: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      folder['name'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontFamily: 'majalla'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (controller.isLoading == false)
                          GetBuilder<GalleryController>(
                            builder: (cont) {
                              return controller.selectedAssets.contains(folder)
                                  ? Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
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
              ),
            );
          }),
    );
  }
}

class FolderImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height - 20)
      ..quadraticBezierTo(0, size.height, 20, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height - 20)
      ..quadraticBezierTo(
          size.width, size.height, size.width - 20, size.height - 20)
      ..lineTo(20, size.height - 20)
      ..quadraticBezierTo(0, size.height - 20, 0, size.height - 40)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
