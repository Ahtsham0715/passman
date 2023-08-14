import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/res/components/folder_assets_page.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({super.key});

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  List<AssetPathEntity> folders = [];
  Map foldersThumbnail = {};
List selectedAssets = [];
  @override
  void initState() {
    super.initState();
    fetchFolders();
  }

  Future<void> fetchFolders() async {
    
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      hasAll: false,
      // onlyAll: true,
    );
   
    setState(() {
      folders = albums;
       albums.forEach((element) async {
      var albumData = await element.getAssetListRange(start: 0, end: 10);
      foldersThumbnail[element.id.toString()] = albumData.last;
    });
    });
  }

  void toggleAssetSelection( asset) {
    if (selectedAssets.contains(asset)) {
      setState(() {
        selectedAssets.remove(asset);
      });
    } else {
      setState(() {
        selectedAssets.add(asset);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery Folders'),
      ),
      body: GridView.builder(
        itemCount: folders.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final folder = folders[index];
final isSelected = selectedAssets.contains(folder);
          return InkWell(
            onTap: () {
              Get.to(() => FolderAssetsPage(folder: folder));
              // Handle folder selection
            },
            onLongPress: (){
              toggleAssetSelection(folder);
            },
            child: Stack(
              children: [
                Container(
                  width: 200,
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: AssetEntityImageProvider(
                          foldersThumbnail[folder.id.toString()],
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
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (isSelected)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 30.0,
                    ),
                  ),
              ],
            ),
          );
        },
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