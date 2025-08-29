import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'secrets.dart';
import 'conversation_service.dart';
import 'chat_message.dart';
import 'character_service.dart';
import 'gallery_screen.dart';

const String apiKey = geminiApiKey;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ConversationService _conversationService = ConversationService();
  
  XFile? _originalImageFile;
  Uint8List? _originalImageBytes;
  Uint8List? _currentImageData;
  
  final Map<String, Uint8List> _emotionImageCache = {};

  bool _isLoading = false;
  String? _error;
  String? _currentEmotion;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _saveData() async {
    if (kIsWeb) return; 

    final prefs = await SharedPreferences.getInstance();
    if (_originalImageFile != null) {
      await prefs.setString('original_image_path', _originalImageFile!.path);
    } else {
      await prefs.remove('original_image_path');
    }
    final Map<String, String> cachePaths = {};
    for (var entry in _emotionImageCache.entries) {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/${entry.key}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await File(filePath).writeAsBytes(entry.value);
        cachePaths[entry.key] = filePath;
    }
    await prefs.setString('emotion_cache_paths', jsonEncode(cachePaths));
    await _conversationService.saveData();
  }

  Future<void> _loadData() async {
    await _conversationService.loadData();
    if (kIsWeb) return;

    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('original_image_path');
    if (imagePath != null && await File(imagePath).exists()) {
      _originalImageFile = XFile(imagePath);
      _originalImageBytes = await _originalImageFile!.readAsBytes();
      _currentImageData = _originalImageBytes;
      
      final cacheJson = prefs.getString('emotion_cache_paths');
      if (cacheJson != null) {
        final Map<String, dynamic> cachePaths = jsonDecode(cacheJson);
        for (var entry in cachePaths.entries) {
          if (await File(entry.value).exists()) {
            _emotionImageCache[entry.key] = await File(entry.value).readAsBytes();
          }
        }
      }
    }
    setState(() {});
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _originalImageFile = pickedFile;
          _originalImageBytes = imageBytes;
          _currentImageData = imageBytes;
          _conversationService.clearMessages();
          _emotionImageCache.clear();
          _currentEmotion = null;
          _error = null;
        });
        await _saveData();
      }
    } catch (e) {
      setState(() { _error = "Failed to pick image: $e"; });
    }
  }

  void _openGallery() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryScreen(
          imageCache: _emotionImageCache,
          originalImageBytes: _originalImageBytes,
        ),
      ),
    );
  }

  Future<void> _showClearHistoryConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Chat History?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This will permanently delete the conversation.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Clear'),
              onPressed: () {
                setState(() {
                  _conversationService.clearMessages();
                });
                _conversationService.saveData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendCommand() async {
    if (apiKey == 'YOUR_GEMINI_API_KEY') {
      setState(() { _error = 'Please add your Gemini API key.'; });
      return;
    }
    if (_originalImageBytes == null) {
      setState(() { _error = 'Please select a character image first.'; });
      return;
    }
    if (_textController.text.isEmpty) {
      return;
    }

    final userMessage = ChatMessage(text: _textController.text, isUser: true);
    setState(() {
      _conversationService.addMessage(userMessage);
      _isLoading = true;
      _error = null;
    });
    _textController.clear();
    await _conversationService.saveData();

    try {
      final baseImageBytes = _originalImageBytes!;
      
      final aiResponse = await CharacterService.getEmotionalResponse(
          _conversationService.getHistoryForPrompt(), baseImageBytes);

      if (aiResponse != null) {
        setState(() {
          _currentEmotion = aiResponse.emotion.toUpperCase();
          _conversationService.addMessage(ChatMessage(text: aiResponse.chatText, isUser: false));
        });

        Uint8List? newImageData;
        final emotionKey = aiResponse.emotion.toLowerCase();

        if (_emotionImageCache.containsKey(emotionKey)) {
          newImageData = _emotionImageCache[emotionKey];
        } else {
          final generatedBytes = await CharacterService.generateEmotionalImage(
              aiResponse.emotion, baseImageBytes);
          
          if (generatedBytes != null) {
            newImageData = generatedBytes;
            _emotionImageCache[emotionKey] = generatedBytes;
            await _saveData();
          }
        }
        
        if (newImageData != null) {
          setState(() {
            _currentImageData = newImageData;
          });
        }
      } else {
        setState(() { _error = "The character didn't respond."; });
      }

    } catch (e) {
      setState(() { _error = 'An error occurred: $e'; });
    } finally {
      setState(() { _isLoading = false; });
      await _conversationService.saveData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ViveChat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _showClearHistoryConfirmationDialog,
            tooltip: 'Clear Chat History',
          ),
          IconButton(
            icon: const Icon(Icons.collections),
            onPressed: _openGallery,
            tooltip: 'Emotion Gallery',
          ),
          IconButton(
            icon: const Icon(Icons.add_photo_alternate),
            onPressed: _pickImage,
            tooltip: 'Select Character Image',
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 200,
            child: _currentImageData != null
                ? Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Center(child: Image.memory(_currentImageData!)),
                      if (_currentEmotion != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _currentEmotion!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                  )
                : Center(
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Select a Character'),
                    ),
                  ),
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _conversationService.messages.length,
              itemBuilder: (context, index) {
                final message = _conversationService.messages[index];
                return ListTile(
                  title: Align(
                    alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: message.isUser ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(message.text),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Chat with your character...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendCommand(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isLoading ? null : _sendCommand,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
