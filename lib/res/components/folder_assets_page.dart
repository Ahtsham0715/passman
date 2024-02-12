import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/media%20files/controllers/gallery_controller.dart';
import 'package:passman/res/components/full_image_view.dart';
// import 'package:photo_manager/photo_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../constants.dart';

class FolderAssetsPage extends StatefulWidget {
  final FileSystemEntity folder;

  FolderAssetsPage({required this.folder});

  @override
  State<FolderAssetsPage> createState() => _FolderAssetsPageState();
}

class _FolderAssetsPageState extends State<FolderAssetsPage> {
  final GalleryController cont = Get.find();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        cont.getFiles(widget.folder).then((value) {
          cont.isLoadingFiles = false;
          cont.update(['FilesView', true]);
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        // backgroundColor: Colors.green,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          widget.folder.path.split('/').last,
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
          IconButton(
            onPressed: () {
              // Handle selection action (e.g., upload selected assets)
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        // height: height,
        // width: width,
        decoration: BoxDecoration(
          gradient: bodyGradient(context),
        ),
        child: GetBuilder<GalleryController>(
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
                  // final isSelected = controller.selectedFiles.contains(file);
                  return GestureDetector(
                    // onTap: () async {
                    //   //  var afile =  await asset.file;
                    //   //  var bytes = await afile!.readAsBytes();
                    //   //  log(bytes.toString());
                    //   // controller.toggleFileSelection(file);
                    // },
                    onTap: 
                   controller.isLoadingFiles ? null : 
                    () {
                      Get.to(() => FullScreenImagePage(
                            imageUrl: file['path'],
                          ));
                    },
                    child: Skeletonizer(
                      enabled: controller.isLoadingFiles,
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        width: 200,
                          height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey.shade400,
                          image: 
                          controller.isLoadingFiles ? null :
                          DecorationImage(
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
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
