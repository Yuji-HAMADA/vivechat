import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:universal_html/html.dart' as html;
import 'package:vivechat/generated/app_localizations.dart';

class FullScreenImageViewer extends StatelessWidget {
  final Uint8List? imageBytes;
  final File? imageFile;

  const FullScreenImageViewer({super.key, this.imageBytes, this.imageFile});

  Future<void> _downloadImage(BuildContext context) async {
    Uint8List? bytes;
    if (imageBytes != null) {
      bytes = imageBytes;
    } else if (imageFile != null) {
      bytes = await imageFile!.readAsBytes();
    }

    if (bytes != null) {
      if (kIsWeb) {
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute("download", "image.png")
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final result = await SaverGallery.saveImage(bytes, fileName: 'image.png', androidRelativePath: 'Pictures/ViveChat', skipIfExists: false);
        if (result.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.imageSavedToGallery)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.failedToSaveImage)),
          );
        }
      }
    }
  }

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
        body: Center(child: Text(AppLocalizations.of(context)!.imageNotAvailable)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadImage(context),
          ),
        ],
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
