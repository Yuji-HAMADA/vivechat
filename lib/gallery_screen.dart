import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryScreen extends StatelessWidget {
  final Map<String, XFile> imageCache;
  final XFile? originalImage;

  const GalleryScreen({super.key, required this.imageCache, this.originalImage});

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, XFile>> imageList = [];

    // Add the original image first if it exists
    if (originalImage != null) {
      imageList.add(MapEntry('ORIGINAL', originalImage!));
    }
    // Add the cached emotional images
    imageList.addAll(imageCache.entries);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Image Gallery'),
      ),
      body: imageList.isEmpty
          ? const Center(
              child: Text(
                'No images have been generated or selected yet.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                final entry = imageList[index];
                final caption = entry.key;
                final imageFile = entry.value;

                return GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black54,
                    title: Text(
                      caption.toUpperCase(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  child: Image.file(
                    File(imageFile.path),
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
    );
  }
}