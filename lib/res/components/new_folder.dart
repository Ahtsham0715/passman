import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/media%20files/controllers/media_controller.dart';

class showNewFolderDialog extends StatefulWidget {
  final String name;
  final String type;
  final bool isEdit;
  const showNewFolderDialog(
      {super.key,
      required this.name,
      required this.type,
      required this.isEdit});

  @override
  State<showNewFolderDialog> createState() => _showNewFolderDialogState();
}

class _showNewFolderDialogState extends State<showNewFolderDialog> {
  TextEditingController _folderNameController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final MediaController controller = MediaController();
  int selectedval = 0;
  @override
  void initState() {
    _folderNameController.text = widget.name;
    // controller.selectedRadio = 0;
    widget.type == 'Images'
        ? controller.selectedRadio = 0
        : controller.selectedRadio = 1;
    //     : widget.type == 'Videos'
    //         ? controller.selectedRadio = 1
    //         : controller.selectedRadio = 2;
    selectedval = controller.selectedRadio;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      scrollable: true,
      title: Text(
        "Enter Folder Name",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontSize: 22.0,
          fontFamily: 'majalla',
        ),
      ),
      content: Container(
        // width: double.maxFinite,
        // height: context.blockSizeVertical * 120,
        child: Column(
          children: [
            Form(
              key: formkey,
              child: TextFormField(
                controller: _folderNameController,
                obscureText: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Folder name required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Folder Name",
                  prefixIcon: Icon(Icons.folder_open),
                ),
              ),
            ),
            widget.isEdit
                ? const Center()
                : GetBuilder<MediaController>(
                    init: MediaController(),
                    builder: (_) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RadioListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                            value: 0,
                            groupValue: _.selectedRadio,
                            title: Text('Images'),
                            onChanged: (value) {
                              _.selectedRadio = value!;
                              selectedval = value;
                              print(_.selectedRadio);

                              _.update();
                            },
                          ),
                          RadioListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                            value: 1,
                            groupValue: _.selectedRadio,
                            title: Text('Passwords'),
                            onChanged: (value) {
                              _.selectedRadio = value!;
                              selectedval = value;

                              print(_.selectedRadio);

                              _.update();
                            },
                          ),
                          // RadioListTile(
                          //   dense: true,
                          //   contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                          //   value: 1,
                          //   groupValue: _.selectedRadio,
                          //   title: Text('Videos'),
                          //   onChanged: (value) {
                          //     _.selectedRadio = value!;
                          //     selectedval = value;

                          //     print(_.selectedRadio);

                          //     _.update();
                          //   },
                          // ),
                          // RadioListTile(
                          //   dense: true,
                          //   contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                          //   value: 2,
                          //   groupValue: _.selectedRadio,
                          //   title: Text('All'),
                          //   onChanged: (value) {
                          //     _.selectedRadio = value!;
                          //     selectedval = value;

                          //     print(_.selectedRadio);

                          //     _.update();
                          //   },
                          // ),
                        ],
                      );
                    },
                  ),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.all(0.0),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 0.0,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'majalla',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: Text(
                "Create",
                style: TextStyle(
                  color: Colors.green.shade800,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'majalla',
                ),
              ),
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  print('selected radio: ${controller.selectedRadio}');
                  print('selected radio: ${selectedval}');
                  var type = selectedval == 0 ? 'Images' : 'Passwords';
                  // selectedval == 1
                  //     ? 'Videos'
                  //     : 'All';
                  Navigator.of(context).pop({
                    'name': _folderNameController.text,
                    'type': type,
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
