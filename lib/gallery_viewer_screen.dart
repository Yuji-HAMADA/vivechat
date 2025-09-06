import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:universal_html/html.dart' as html;
import 'package:vivechat/generated/app_localizations.dart';

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

  Future<void> _downloadImage() async {
    final int currentIndex = _pageController.page!.round();
    final Uint8List imageBytes = widget.imageList[currentIndex].value;

    if (kIsWeb) {
      final blob = html.Blob([imageBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", "image.png")
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final messenger = ScaffoldMessenger.of(context);
      final result = await SaverGallery.saveImage(
        imageBytes,
        fileName: 'image.png',
        androidRelativePath: 'Pictures/ViveChat',
        skipIfExists: false,
      );
      if (result.isSuccess) {
        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.imageSavedToGallery)),
        );
      } else {
        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.failedToSaveImage)),
        );
      }
    }
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
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadImage,
          ),
        ],
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
          return Hero(
            tag: 'galleryHero_${imageBytes.hashCode}_$index',
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 1.0,
              maxScale: 4.0,
              child: Center(
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
