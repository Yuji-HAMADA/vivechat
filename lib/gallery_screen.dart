import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'gallery_viewer_screen.dart';
import 'package:vivechat/generated/app_localizations.dart';

class GalleryScreen extends StatelessWidget {
  final Map<String, Uint8List> imageCache;
  final Uint8List? originalImageBytes;

  const GalleryScreen({super.key, required this.imageCache, this.originalImageBytes});

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, Uint8List>> imageList = [];
    if (originalImageBytes != null) {
      imageList.add(MapEntry(AppLocalizations.of(context)!.original, originalImageBytes!));
    }
    imageList.addAll(imageCache.entries);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.characterEmotionGallery),
      ),
      body: imageList.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.noEmotionalImages,
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
                final imageBytes = entry.value;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryViewerScreen(
                          imageList: imageList,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'galleryHero_${imageBytes.hashCode}_$index',
                    child: GridTile(
                      footer: GridTileBar(
                        backgroundColor: Colors.black54,
                        title: Text(
                          caption.toUpperCase(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      child: Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
