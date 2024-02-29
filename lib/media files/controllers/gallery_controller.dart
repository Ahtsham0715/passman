import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/res/components/custom_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
// import 'package:photo_manager/photo_manager.dart';

class GalleryController extends GetxController {
  List selectedAssets = [];
  List<AssetEntity> selectedFiles = [];
  bool isLoading = false;
  bool isLoadingFiles = false;
  bool isHidingDirectories = false;
  // List<FileSystemEntity> subDirs = [];
  List<FileSystemEntity> subDirectories = [];
  List availableFolders = [];

  List dummyAvailableFolders = List.generate(
      10,
      (index) => {
            'folder': '',
            'name': 'asdjfhsd',
            'thumbnail': '',
          });

  List availableFiles = [];

  List dummyAvailableFiles = List.generate(
    10,
    (index) => {
      'name': 'jndsfh',
      'path': '',
      'file': '',
    },
  );

  final FilterOptionGroup _filterOptionGroup = FilterOptionGroup(
    imageOption: const FilterOption(
      sizeConstraint: SizeConstraint(ignoreSize: true),
    ),
  );
  @override
  void onInit() {
    // getFoldersUsingPhotoManager().then((value) {
    //   // log(availableFolders.toString());
    //   isLoading = false;
    //   update(['GalleryView', true]);
    // });
    // getFolders().then((value) {
    //   log(availableFolders.toString());
    //   isLoading = false;
    //   update(['GalleryView', true]);
    // });
    super.onInit();
  }

  Future getFoldersUsingPhotoManager() async {
    // isLoading = true;
    // update(['GalleryView', true]);
    availableFolders.clear();
    //  availableFolders.add({
    //           'folder': element,
    //           'name': element.path.split('/').last.toString(),
    //           'thumbnail': thisDirFiles.first.path,
    //         });
    PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.hasAccess) {
      final List<AssetPathEntity> dirs = await PhotoManager.getAssetPathList(
        // onlyAll: true,
        hasAll: false,
        onlyAll: false,

        type: RequestType.image,
        filterOption: _filterOptionGroup,
      );
      log(dirs.toString(), name: 'paths');
      for (var dir in dirs) {
        PhotoManager.clearFileCache();

        var subpathlist = await dir.getSubPathList();
        if (subpathlist.isEmpty) {
          // int assetsCount = await dir.assetCountAsync;
          var assetlistrange = await dir.getAssetListRange(start: 0, end: 10);
          if (assetlistrange.isNotEmpty) {
            var assetlistrangefirstthumbnail = assetlistrange.isEmpty
                ? File('')
                : await assetlistrange.first.file;
            availableFolders.add({
              'folder': dir,
              'name': dir.name,
              'thumbnail': await assetlistrangefirstthumbnail!.readAsBytes(),
            });
          } else {
            // print(assetlistrange);
          }
        } else {
          for (var subdir in subpathlist) {
            var assetlistrange =
                await subdir.getAssetListRange(start: 0, end: 10);
            var assetlistrangefirstthumbnail =
                await assetlistrange.first.thumbnailData;
            availableFolders.add({
              'folder': subdir,
              'name': subdir.name,
              'thumbnail': assetlistrangefirstthumbnail,
            });
          }
        }
        // var pathproperties = await dir.fetchPathProperties();

        // // var assetlistpaged = await dir.getAssetListPaged(page: 0, size: 1000);
        // log(subpathlist.toString(), name: 'subpathlist');
        // log(pathproperties.toString(), name: 'pathproperties');
        // log(assetlistrange.toString(), name: 'getassetlistrange');
        // log(assetlistrangefirstmediaurl.toString(),
        //     name: 'firstitemgetassetlistrange');
        // log(assetlistpaged.toString(), name: 'getassetlistpaged');
      }
      update(['GalleryView']);
    } else {
      styledsnackbar(
          txt: 'Allow storage permission to use this featue',
          icon: Icons.warning);
      // openAppSettings();
      await PhotoManager.requestPermissionExtend();
      update(['GalleryView', true]);
    }
    return availableFolders;
  }

  Future getFolders() async {
    isLoading = true;
    update(['GalleryView', true]);
    availableFolders.clear();
    var str = await Permission.manageExternalStorage.status;
    // log(str.toString());
    if (str.isGranted || str.isRestricted) {
      Directory dir = Directory('/storage/emulated/0/Download');
      print(await dir.exists());

      // Directory? directory = await path.getExternalStorageDirectory();
      // List<FileSystemEntity> files = directory!.listSync(recursive: true);
      List<FileSystemEntity> dirsList = await dir.list().toList();
      // log(dirsList.toString(), name: 'directories list');
      for (var element in dirsList) {
        print(element.path);
        print(element);
        if (await FileSystemEntity.isDirectory(element.path)) {
          Directory thisDir = Directory(element.path);
          List<FileSystemEntity> thisDirFiles = await thisDir.list().toList();
          // log(thisDirFiles.toString(), name: 'directory files');
          if (thisDirFiles.isNotEmpty) {
            availableFolders.add({
              'folder': element,
              'name': element.path.split('/').last.toString(),
              'thumbnail': thisDirFiles.first.path,
            });
            await getSubDirs(thisDirFiles).then((thisSubDirs) async {
              log(thisSubDirs.toString(), name: 'sub directories');
              if (thisSubDirs.isNotEmpty) {
                for (var subdir in thisSubDirs) {
                  List<FileSystemEntity> thisSubDirFiles =
                      await Directory(subdir.path).list().toList();
                  if (thisSubDirFiles.isNotEmpty) {
                    availableFolders.add({
                      'folder': subdir,
                      'name': subdir.path.split('/').last.toString(),
                      'thumbnail': thisSubDirFiles.first.path,
                    });
                  }
                }
              }
              // else {
              //   availableFolders.add({
              //     'folder': element,
              //     'name': element.path.split('/').last.toString(),
              //     'thumbnail': thisDirFiles.first.path,
              //   });
              // }
            });
          }

          print('Directory');
        }
        // else if (await FileSystemEntity.isFile(element.path)) {
        //   print('file');
        // }
      }
    } else {
      Permission.storage.request();
    }
  }

  Future<List<FileSystemEntity>> getSubDirs(List<FileSystemEntity> dirs) async {
    subDirectories.clear();
    await Future.forEach(dirs, (thiselement) async {
      if (await FileSystemEntity.isDirectory(thiselement.path)) {
        subDirectories.add(thiselement);
        print('this is Directory: ${subDirectories}');
      }
    });
    return subDirectories;
  }

  Future getFilesUsingPathManager(AssetPathEntity folder) async {
    // isLoadingFiles = true;
    // update(
    //   ['FilesView', true],
    // );
    availableFiles.clear();
    var files = await folder.getAssetListRange(start: 0, end: 5000);
    if (files.isNotEmpty) {
      for (var file in files) {
        var imgFile = await file.file;
        availableFiles.add({
          'name': file.title.toString(),
          'path': imgFile!.absolute.path,
          'file': file,
        });
      }
    }
    update(
      ['FilesView', true],
    );
    return availableFiles;
  }

  Future<void> deleteFile(String filePath) async {
    final status = await Permission.manageExternalStorage.status;
    try {
      if (status.isGranted) {
        File(filePath).delete(recursive: true);
      } else {
        await Permission.manageExternalStorage.request();
        File(filePath).delete(recursive: true);
      }
    } catch (e) {
      print('file deletion error: $e');
    }
    update(
      ['FilesView', true],
    );
  }

  Future getFiles(FileSystemEntity folder) async {
    isLoadingFiles = true;
    update(
      ['FilesView', true],
    );
    availableFiles.clear();

    Directory thisDir = Directory(folder.path);
    List<FileSystemEntity> thisDirFiles = await thisDir.list().toList();
    log(thisDirFiles.length.toString(), name: 'files length');
    for (var file in thisDirFiles) {
      if (await FileSystemEntity.isFile(file.path) && file.path.isImageFileName)
        availableFiles.add({
          'name': file.path.split('/').last.toString(),
          'path': file.path.toString(),
          'file': file,
        });
    }
  }

  // Future<void> fetchFolders() async {
  //   isLoading = true;
  //   update();
  //   final albums = await PhotoManager.getAssetPathList(
  //     type: RequestType.image,
  //     hasAll: false,

  //     // onlyAll: true,
  //   );
  //   albums.forEach((element) async {
  //     var albumData = await element.getAssetListRange(start: 0, end: 10);
  //     foldersThumbnail[element.id.toString()] = albumData.last;
  //     update();
  //   });

  //   folders = albums;
  // }

  Future<void> createNoMediaFile(String directoryPath) async {
    final noMediaFile = File('$directoryPath/.nomedia');
    if (!noMediaFile.existsSync()) {
      await noMediaFile.create();
      // noMediaFile.rename('$destinationPath/.nomedia');
    }
  }

  Future<void> copyDirectory(Directory destination) async {
    if (!await destination.exists()) {
      await destination.create(recursive: true);
    }
  }

  void toggleAssetSelection(asset) {
    if (selectedAssets.contains(asset)) {
      selectedAssets.remove(asset);
      update(['GalleryView', true]);
    } else {
      selectedAssets.add(asset);
      update(['GalleryView', true]);
    }
  }

  void toggleFileSelection(file) {
    if (selectedFiles.contains(file)) {
      selectedFiles.remove(file);

      // update(['FilesView', true]);
    } else {
      selectedFiles.add(file);
      // update(['FilesView', true]);
    }
    if (selectedFiles.isEmpty || selectedFiles.length < 2) {
      update(['selectedIcon', 'showCheckButton', 'selectedFilesCount'], true);
    } else {
      update(['selectedIcon', 'selectedFilesCount'], true);
    }
  }
}
