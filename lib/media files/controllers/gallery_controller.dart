import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:photo_manager/photo_manager.dart';

class GalleryController extends GetxController {
  List selectedAssets = [];
  List selectedFiles = [];
  bool isLoading = false;
  bool isLoadingFiles = false;
  bool isHidingDirectories = false;
  // List<FileSystemEntity> subDirs = [];
  List<FileSystemEntity> subDirectories = [];

  List availableFolders = [

  ];
 
  List dummyAvailableFolders = [
    {
      'folder': '',
      'name': 'asdjfhsd',
      'thumbnail': '',
    },
    {
      'folder': '',
      'name': 'sdjfhsd',
      'thumbnail': '',
    },
    {
      'folder': '',
      'name': 'jnsdjfh',
      'thumbnail': '',
    },
    {
      'folder': '',
      'name': 'sdjfhsd',
      'thumbnail': '',
    },
    {
      'folder': '',
      'name': 'jnsdjfh',
      'thumbnail': '',
    },
    {
      'folder': '',
      'name': 'sdjfhsd',
      'thumbnail': '',
    },
    {
      'folder': '',
      'name': 'jnsdjfh',
      'thumbnail': '',
    },
    {
      'folder': '',
      'name': 'jnsdjfrtyhsd',
      'thumbnail': '',
    },
    {
      'folder': '',
      'name': 'jnsdjfdfsd',
      'thumbnail': '',
    },
  ];
 
  List availableFiles = [

  ];
 
 
  List dummyAvailableFiles = [
    {
      'name': 'jndsfh',
      'path': '',
      'file': '',
    },
    {
      'name': '335dsfh',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasjf33h',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasdsfh',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasjf5dsfh',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasjf5dsfh',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasjf33h',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasdsfh',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasjf5dsfh',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasjf5dsfh',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasjf33h',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasdsfh',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasjf5dsfh',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasjf5dsfh',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasjf33h',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasdsfh',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasjf5dsfh',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasjf5dsfh',
      'path': '',
      'file': '',
    },
    {
      'name': 'jnasjf335dsfh',
      'path': '',
      'file': '',
    },
  ];
 
 
  @override
  void onInit() {
    getFolders().then((value) {
      log(availableFolders.toString());
      isLoading = false;
      update(['GalleryView', true]);
    });
    super.onInit();
  }

  Future getFolders() async {
    isLoading = true;
    update(['GalleryView', true]);
    availableFolders.clear();
    var str = await Permission.manageExternalStorage.status;
    // log(str.toString());
    if (str.isGranted || str.isRestricted) {
      Directory dir = Directory('/storage/emulated/0/DCIM');

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

  Future getFiles(FileSystemEntity folder) async {
    isLoadingFiles = true;
    update(['FilesView', true],);
    availableFiles.clear();
    
    Directory thisDir = Directory(folder.path);
    List<FileSystemEntity> thisDirFiles = await thisDir.list().toList();
    log(thisDirFiles.length.toString(), name: 'files length');
    for (var file in thisDirFiles) {
      if(await FileSystemEntity.isFile(file.path) && file.path.isImageFileName)
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
  }}

  void toggleAssetSelection(asset) {
    if (selectedAssets.contains(asset)) {
      selectedAssets.remove(asset);
      update(['GalleryView', true]);
    } else {
      selectedAssets.add(asset);
      update(['GalleryView', true]);
    }
  }

  // void toggleFileSelection(file) {
  //   if (selectedFiles.contains(file)) {
  //     selectedFiles.remove(file);
  //     update();
  //   } else {
  //     selectedFiles.add(file);
  //     update();
  //   }
  // }
}
