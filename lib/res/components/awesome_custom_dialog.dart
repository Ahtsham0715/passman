import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:get/get.dart';


Future<void> customAwesomeDialog({
  AnimType animType = AnimType.topSlide,
  DialogType dialogType = DialogType.question,
  String title = 'Are you sure?',
  required String details,
  required void Function()? okpress,
}) async {
   AwesomeDialog(
    context: Get.context!,
    animType: animType,
    dialogType: dialogType,
    // body: Center(child: Text(
    //         'If the body is specified, then title and description will be ignored, this allows to 											further customize the dialogue.',
    //         style: TextStyle(fontStyle: FontStyle.italic),
    //       ),),
    title: title,
    desc: details,
    btnOkOnPress: okpress,
    btnCancelOnPress: () {
      // Get.back();
    },
  )..show();
}
