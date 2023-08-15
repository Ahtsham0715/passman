import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../constants.dart';

class FolderAssetsPage extends StatefulWidget {
  final AssetPathEntity folder;

  FolderAssetsPage({required this.folder});

  @override
  _FolderAssetsPageState createState() => _FolderAssetsPageState();
}

class _FolderAssetsPageState extends State<FolderAssetsPage> {
   List<AssetEntity> assets = [];
  List<AssetEntity> selectedAssets = [];

  @override
  void initState() {
    super.initState();
    fetchAssets();
  }

  Future<void> fetchAssets() async {
    final assetList = await widget.folder.getAssetListRange(start: 0, end: 1000);
    setState(() {
      assets = assetList;
    });
  }

  void toggleAssetSelection(AssetEntity asset) {
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
      appBar: 
        AppBar(
        // automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        // backgroundColor: Colors.green,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          widget.folder.name,
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
        child: GridView.builder(
          itemCount: assets.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final asset = assets[index];
            final isSelected = selectedAssets.contains(asset);
            return GestureDetector(
              onTap: ()async {
              //  var afile =  await asset.file;
              //  var bytes = await afile!.readAsBytes();
              //  log(bytes.toString());
                toggleAssetSelection(asset);
              },
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
      
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(image: AssetEntityImageProvider(asset, isOriginal: true, ),fit: BoxFit.fill),
                    ),
                    // child: Image(
                    //   image: AssetEntityImageProvider(asset, isOriginal: true, ),
                    //   fit: BoxFit.fill,
                    // ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
