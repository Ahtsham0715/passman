import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';
import 'package:passman/constants.dart';

class UserDataController extends GetxController {
  @override
  void onInit() {
    // getUserData();
    super.onInit();
  }

  Future getUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(logininfo.get('userid'))
        .get()
        .then((DocumentSnapshot userdata) {
      logininfo.put('name', userdata['name']);
      update();
    });
  }
}
