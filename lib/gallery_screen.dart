import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryScreen extends StatelessWidget {
  final Map<String, XFile> imageCache;

  const GalleryScreen({super.key, required this.imageCache});

  @override
  Widget build(BuildContext context) {
    // Create a list from the map to easily access items by index
    final List<MapEntry<String, XFile>> imageList = imageCache.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Emotion Gallery'),
      ),
      body: imageList.isEmpty
          ? const Center(
              child: Text(
                'No emotional images have been generated yet.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                final entry = imageList[index];
                final emotion = entry.key;
                final imageFile = entry.value;

                return GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black54,
                    title: Text(
                      emotion.toUpperCase(),
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
