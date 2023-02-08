import 'package:flutter/material.dart';

class showNewFolderDialog extends StatefulWidget {
  const showNewFolderDialog({super.key});

  @override
  State<showNewFolderDialog> createState() => _showNewFolderDialogState();
}

class _showNewFolderDialogState extends State<showNewFolderDialog> {
  TextEditingController _folderNameController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

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
      actions: [
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
              Navigator.of(context).pop(_folderNameController.text);
            }
          },
        ),
      ],
    );
  }
}
