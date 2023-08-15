import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryController extends GetxController {
  RxList folders = [].obs;
  RxMap foldersThumbnail = {}.obs;
  List selectedAssets = [];
  RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    fetchFolders().then((value) {
      isLoading.value = false;
    });
    super.onInit();
  }

  Future<void> fetchFolders() async {
    isLoading.value = true;
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      hasAll: false,
      // onlyAll: true,
    );
    albums.forEach((element) async {
      var albumData = await element.getAssetListRange(start: 0, end: 10);
      foldersThumbnail[element.id.toString()] = albumData.last;
    });

    folders.value = albums;
  }

  void toggleAssetSelection(asset) {
    if (selectedAssets.contains(asset)) {
      selectedAssets.remove(asset);
    update();
    } else {
      selectedAssets.add(asset);
    update();
    }
  }
}
