import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFunction;

  UserImagePicker(this.imagePickFunction);
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 150,
    );
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
    widget.imagePickFunction(File(pickedImageFile!.path));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
        radius: 50,
        child: _pickedImage == null
            ? Text(
                "Add Image",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )
            : null,
      ),
    );
  }
}
