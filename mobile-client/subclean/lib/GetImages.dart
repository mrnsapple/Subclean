import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

Widget decideImageView({@required File imageFile}) {
  if (imageFile is Text)
    return Center(
      child:
          Container(color: Colors.grey, child: Center(child: Text("No Image Selected!", style: TextStyle(color: Colors.black),)), width: 400, height: 400),
    );
  if (imageFile is String)
    return Center(
      child:
      Container(color: Colors.grey, child: Center(child: Text("No Image Selected!", style: TextStyle(color: Colors.black),)), width: 400, height: 400),
    );
  if (imageFile == null)
    return Center(
      child:
      Container(color: Colors.grey, child: Center(child: Text("No Image Selected!", style: TextStyle(color: Colors.black),)), width: 400, height: 400),
    );
  if (imageFile.path == null)
    return Center(
      child:
      Container(color: Colors.grey, child: Center(child: Text("No Image Selected!", style: TextStyle(color: Colors.black),)), width: 400, height: 400),
    );
  return Image.file(imageFile, width: 400, height: 400);
}

Future<File> openCamera() async {
  ImagePicker picker = new ImagePicker();
  PickedFile imageFile;

  imageFile = await picker.getImage(source: ImageSource.camera);

  return File(imageFile.path);
}

Future<File> openGallery() async {
  ImagePicker picker = new ImagePicker();
  PickedFile imageFile;

  imageFile = await picker.getImage(source: ImageSource.gallery);

  return File(imageFile.path);
}
