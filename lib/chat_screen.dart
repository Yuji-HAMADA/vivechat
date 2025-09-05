import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivechat/full_screen_image_viewer.dart';
import 'package:vivechat/home_screen.dart';
import 'conversation_service.dart';
import 'chat_message.dart';
import 'character_service.dart';
import 'gallery_screen.dart';
import 'image_update_service.dart';

class ChatScreen extends StatefulWidget {
  final String character;
  const ChatScreen({super.key, required this.character});
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
  bool _isImageUpdateMode = false;

  @override
  void initState() {
    super.initState();
    _loadCharacter();
  }

  @override
  void didUpdateWidget(ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.character != oldWidget.character) {
      _loadCharacter();
    }
  }

  Future<void> _loadCharacter() async {
    if (widget.character.startsWith('assets/')) {
      final byteData = await rootBundle.load(widget.character);
      setState(() {
        _originalImageBytes = byteData.buffer.asUint8List();
        _currentImageData = _originalImageBytes;
      });
    } else {
      if (kIsWeb) {
        final xfile = XFile(widget.character);
        final imageBytes = await xfile.readAsBytes();
        setState(() {
          _originalImageFile = xfile;
          _originalImageBytes = imageBytes;
          _currentImageData = imageBytes;
        });
      } else {
        final imageFile = File(widget.character);
        if (await imageFile.exists()) {
          final imageBytes = await imageFile.readAsBytes();
          setState(() {
            _originalImageFile = XFile(widget.character);
            _originalImageBytes = imageBytes;
            _currentImageData = imageBytes;
          });
        }
      }
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendCommand() async {
    if (_originalImageBytes == null) {
      setState(() { _error = 'Please select a character image first.'; });
      return;
    }
    if (_textController.text.isEmpty) {
      return;
    }

    final promptText = _textController.text;
    _textController.clear();

    if (_isImageUpdateMode) {
      final userMessage = ChatMessage(text: promptText, isUser: true);
      _conversationService.addMessage(userMessage);
      setState(() {
        _isLoading = true;
        _error = null;
      });

      try {
        final baseImageBytes = _originalImageBytes!;
        final imageUpdateResponse = await ImageUpdateService.updateImageFromPrompt(
            promptText, baseImageBytes);

        if (imageUpdateResponse != null) {
          final newEmotionKey = "Updated ${DateTime.now().millisecondsSinceEpoch}";
          if (imageUpdateResponse.imageBytes != null) {
            _emotionImageCache[newEmotionKey] = imageUpdateResponse.imageBytes!;
          }
          setState(() {
            if (imageUpdateResponse.imageBytes != null) {
              _currentImageData = imageUpdateResponse.imageBytes;
              _originalImageBytes = imageUpdateResponse.imageBytes;
            }
            _conversationService.addMessage(ChatMessage(text: imageUpdateResponse.chatText, isUser: false));
            _isImageUpdateMode = false;
          });
        } else {
          setState(() {
            _error = "Failed to update image.";
          });
        }
      } catch (e) {
        setState(() {
          if (e.toString().contains('401')) {
            _error = 'Authentication Failed. Please check your pass key.';
          } else {
            _error = 'An error occurred: $e';
          }
        });
      } finally {
        setState(() { _isLoading = false; });
      }
    } else {
      final userMessage = ChatMessage(text: promptText, isUser: true);
      _conversationService.addMessage(userMessage);
      setState(() {
        _isLoading = true;
        _error = null;
      });

      try {
        final baseImageBytes = _originalImageBytes!;

        final aiResponse = await CharacterService.getEmotionalResponse(
            _conversationService.getHistoryForPrompt(), baseImageBytes);

        if (aiResponse != null) {
          Uint8List? newImageData;
          final emotionKey = aiResponse.emotion.toLowerCase();

          if (_currentEmotion?.toLowerCase() != emotionKey) {
            if (_emotionImageCache.containsKey(emotionKey)) {
              newImageData = _emotionImageCache[emotionKey];
            } else {
              final generatedBytes = await CharacterService.generateEmotionalImage(
                  aiResponse.emotion, baseImageBytes);

              if (generatedBytes != null) {
                newImageData = generatedBytes;
                _emotionImageCache[emotionKey] = generatedBytes;
              }
            }
          }

          setState(() {
            _currentEmotion = aiResponse.emotion.toUpperCase();
            _conversationService.addMessage(ChatMessage(text: aiResponse.chatText, isUser: false));
            if (newImageData != null) {
              _currentImageData = newImageData;
            }
          });
        } else {
          setState(() { _error = "The character didn't respond."; });
        }
      } catch (e) {
        setState(() {
          if (e.toString().contains('401')) {
            _error = 'Authentication Failed. Please check your pass key.';
          } else {
            _error = 'An error occurred: $e';
          }
        });
      } finally {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ViveChat'),
        // 新しい変更: Leading BackButtonにロジックを適用
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
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
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 200,
            child: _currentImageData != null
                ? GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImageViewer(imageBytes: _currentImageData!),
                  ),
                );
              },
              child: Stack(
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
              ),
            )
                : const Center(
              child: CircularProgressIndicator(),
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
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CheckboxListTile(
              title: const Text("Just Update Image"),
              value: _isImageUpdateMode,
              onChanged: (newValue) {
                setState(() {
                  _isImageUpdateMode = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
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