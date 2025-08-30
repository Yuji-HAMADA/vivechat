import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'secrets.dart';
import 'api_constants.dart'; // Import the new constants file

const String apiKey = geminiApiKey;

class AIResponse {
  final String chatText;
  final String emotion;
  AIResponse({required this.chatText, required this.emotion});
}

class CharacterService {
  static Future<AIResponse?> getEmotionalResponse(
      String history, Uint8List imageBytes) async {
    final url = Uri.parse('${ApiConstants.getEndpoint('generateContent')}?key=$apiKey');
    final headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'ViveChat/1.0'
      };

    final prompt = """
You are the character in the image. Your personality is friendly and curious.
Based on the conversation history below, do two things:
1. Determine your current emotion as a single word (e.g., Happy, Sad, Angry, Surprised, Thoughtful, Neutral).
2. Write a natural, in-character response to the user's last message.

Return your response in the following format, and nothing else:
EMOTION: [Your single emotion word]
CHAT: [Your chat response]

Conversation History:
$history
""";

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt},
            {
              'inline_data': {
                'mime_type': 'image/jpeg',
                'data': base64Encode(imageBytes)
              }
            }
          ]
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final candidates = decodedResponse['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content']['parts'][0]['text'] as String?;
          if (content != null) {
            String chatText = "I'm not sure what to say.";
            String emotion = "Neutral";
            final lines = content.split('\n');
            for (var line in lines) {
              if (line.startsWith('EMOTION:')) {
                emotion = line.substring('EMOTION:'.length).trim();
              } else if (line.startsWith('CHAT:')) {
                chatText = line.substring('CHAT:'.length).trim();
              }
            }
            return AIResponse(chatText: chatText, emotion: emotion);
          }
        }
        // Log the raw body if parsing fails or content is missing
        print("Character did not respond. Raw response body: ${response.body}");
      } else {
        // Log the raw body if the HTTP request itself fails
        print("Character did not respond. HTTP Error ${response.statusCode}. Raw response body: ${response.body}");
      }
    } catch (e) {
      print("Error getting emotional response: $e");
    }
    return null;
  }

  static Future<Uint8List?> generateEmotionalImage(
      String emotion, Uint8List imageBytes) async {
    final url = Uri.parse('${ApiConstants.getEndpoint('generateContent')}?key=$apiKey');
    final headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'ViveChat/1.0'
      };
    
    final prompt = "A photo of the person in the image with a ${emotion.toLowerCase()} expression on their face.";

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt},
            {
              'inline_data': {
                'mime_type': 'image/jpeg',
                'data': base64Encode(imageBytes)
              }
            }
          ]
        }
      ]
    });

     try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final candidates = decodedResponse['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'] as Map?;
          if (content != null) {
            final parts = content['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              final inlineData = parts[0]['inlineData'] as Map?;
              if (inlineData != null) {
                final imageBytesB64 = inlineData['data'] as String?;
                if (imageBytesB64 != null) {
                  return base64Decode(imageBytesB64);
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print("Error generating emotional image: $e");
    }
    return null;
  }
}