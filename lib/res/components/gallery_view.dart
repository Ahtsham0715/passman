import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/constants.dart';
import 'package:passman/res/components/folder_assets_page.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../media files/controllers/gallery_controller.dart';

// class GalleryView extends StatefulWidget {
//   const GalleryView({super.key});

//   @override
//   State<GalleryView> createState() => _GalleryViewState();
// }

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
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        // height: height,
        // width: width,
        decoration: BoxDecoration(
          gradient: bodyGradient(context),
        ),
        child: Obx(
          () => Skeletonizer(
            enabled: controller.isLoading.value,
            child: GridView.builder(
              itemCount: controller.folders.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final folder = controller.folders[index];
                // final isSelected = controller.selectedAssets.contains(folder);
                print('building... ');
                return InkWell(
                  onLongPress: () {
                    Get.to(() => FolderAssetsPage(folder: folder));
                    // Handle folder selection
                  },
                  onTap: () {
                    print('toggle');
                    controller.toggleAssetSelection(folder);
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetEntityImageProvider(
                                controller
                                    .foldersThumbnail[folder.id.toString()],
                                isOriginal: true,
                              ),
                              fit: BoxFit.fill),
                          color: Colors.blueGrey,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Icon(
                            //   Icons.folder,
                            //   size: 50,
                            //   color: Colors.white,
                            // ),
                            // SizedBox(height: 10),
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                folder.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontFamily: 'majalla'),
                              ),
                            ),
                          ],
                        ),
                      ),
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
          ),
        ),
      ),
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
