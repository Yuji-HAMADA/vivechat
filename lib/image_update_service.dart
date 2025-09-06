import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:vivechat/auth_service.dart';
import 'api_constants.dart';

class ImageUpdateResponse {
  final String chatText;
  final Uint8List? imageBytes;
  ImageUpdateResponse({required this.chatText, this.imageBytes});
}

class ImageUpdateService {
  static Future<ImageUpdateResponse?> updateImageFromPrompt(
      String prompt, Uint8List imageBytes) async {
    final url = Uri.parse(ApiConstants.baseUrl);
    final headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'ViveChat/1.0'
      };

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': "Based on the following prompt, generate a new image and a short confirmation message. Prompt: $prompt"},
            {
              'inline_data': {
                'mime_type': 'image/jpeg',
                'data': base64Encode(imageBytes)
              }
            }
          ]
        }
      ],
      'safetySettings': [
        {
          'category': 'HARM_CATEGORY_HARASSMENT',
          'threshold': 'BLOCK_NONE'
        },
        {
          'category': 'HARM_CATEGORY_HATE_SPEECH',
          'threshold': 'BLOCK_NONE'
        },
        {
          'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
          'threshold': 'BLOCK_NONE'
        },
        {
          'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
          'threshold': 'BLOCK_NONE'
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final candidates = decodedResponse['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final parts = candidates[0]['content']['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            String chatText = "I couldn't update the image.";
            Uint8List? imageBytes;

            for (var part in parts) {
              if (part.containsKey('text')) {
                chatText = part['text'] as String;
              } else if (part.containsKey('inlineData')) {
                final imageBytesB64 = part['inlineData']['data'] as String?;
                if (imageBytesB64 != null) {
                  imageBytes = base64Decode(imageBytesB64);
                }
              }
            }
            return ImageUpdateResponse(chatText: chatText, imageBytes: imageBytes);
          }
        }
      }
    } catch (e) {
      print("Error updating image from prompt: $e");
    }
    return null;
  }
}
