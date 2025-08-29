import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatelessWidget {
  final Uint8List? imageBytes;
  final File? imageFile;

  const FullScreenImageViewer({super.key, this.imageBytes, this.imageFile});

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (imageBytes != null) {
      imageProvider = MemoryImage(imageBytes!);
    } else if (imageFile != null) {
      imageProvider = FileImage(imageFile!);
    } else {
      // Fallback for an unlikely error case
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Image not available')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(), // Tap anywhere to close
        child: Center(
          child: Hero(
            tag: 'imageHero_${imageBytes?.hashCode ?? imageFile?.hashCode}',
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 1.0,
              maxScale: 4.0,
              child: Image(
                image: imageProvider,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
