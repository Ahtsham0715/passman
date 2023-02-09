import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/media%20files/controllers/media_controller.dart';

class showNewFolderDialog extends StatefulWidget {
  const showNewFolderDialog({super.key});

  @override
  State<showNewFolderDialog> createState() => _showNewFolderDialogState();
}

class _showNewFolderDialogState extends State<showNewFolderDialog> {
  TextEditingController _folderNameController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final MediaController controller = MediaController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
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
        width: double.maxFinite,
        child: Form(
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
      ),
      actionsPadding: EdgeInsets.all(0.0),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 8.0,
      ),
      actions: [
        GetBuilder<MediaController>(
          init: MediaController(),
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile(
                  dense: true,
                  value: 0,
                  groupValue: _.selectedRadio,
                  title: Text('Images'),
                  onChanged: (value) {
                    _.selectedRadio = value!;
                    print(_.selectedRadio);

                    _.update();
                  },
                ),
                RadioListTile(
                  dense: true,
                  value: 1,
                  groupValue: _.selectedRadio,
                  title: Text('Videos'),
                  onChanged: (value) {
                    _.selectedRadio = value!;
                    print(_.selectedRadio);

                    _.update();
                  },
                ),
                RadioListTile(
                  dense: true,
                  value: 2,
                  groupValue: _.selectedRadio,
                  title: Text('All'),
                  onChanged: (value) {
                    _.selectedRadio = value!;
                    print(_.selectedRadio);

                    _.update();
                  },
                ),
              ],
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
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
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'majalla',
                ),
              ),
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  Navigator.of(context).pop({
                    'name': _folderNameController.text,
                    'type': controller.selectedRadio == 0
                        ? 'Images'
                        : controller.selectedRadio == 1
                            ? 'Videos'
                            : 'All',
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
