import 'dart:typed_data';
import 'package:flutter/material.dart';

class GalleryViewerScreen extends StatefulWidget {
  final List<MapEntry<String, Uint8List>> imageList;
  final int initialIndex;

  const GalleryViewerScreen({
    super.key,
    required this.imageList,
    required this.initialIndex,
  });

  @override
  State<GalleryViewerScreen> createState() => _GalleryViewerScreenState();
}

class _GalleryViewerScreenState extends State<GalleryViewerScreen> {
  late final PageController _pageController;
  late String _currentCaption;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentCaption = widget.imageList[widget.initialIndex].key.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          _currentCaption,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageList.length,
        onPageChanged: (index) {
          setState(() {
            _currentCaption = widget.imageList[index].key.toUpperCase();
          });
        },
        itemBuilder: (context, index) {
          final imageBytes = widget.imageList[index].value;
          return InteractiveViewer(
            panEnabled: true,
            minScale: 1.0,
            maxScale: 4.0,
            child: Center(
              child: Image.memory(
                imageBytes,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
