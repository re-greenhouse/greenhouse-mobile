import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({super.key, required this.imageFile});
  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: FileImage(imageFile),
    );
  }
}
