import 'package:get/get.dart';
import 'package:passman/constants.dart';

class SettingsController extends GetxController {
  bool bioauth = logininfo.get('bio_auth') ?? false;
  bool allowScreenshots = logininfo.get('allowScreenshot') ?? false;
}
