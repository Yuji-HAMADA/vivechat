import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_message.dart'; // Correctly import the ChatMessage model

class ConversationService {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  void addMessage(ChatMessage message) {
    _messages.insert(0, message);
  }

  void clearMessages() {
    _messages.clear();
  }

  // Constructs the recent history string for the AI prompt
  String getHistoryForPrompt() {
    const int historyLimit = 6;
    final recentMessages = _messages.take(historyLimit).toList().reversed;
    
    String historyForPrompt = '';
    for (var message in recentMessages) {
        historyForPrompt += "${message.isUser ? 'User' : 'You'}: ${message.text}\n";
    }
    return historyForPrompt;
  }

  // --- Persistence ---

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> messagesJson =
        _messages.map((msg) => jsonEncode(msg.toJson())).toList();
    await prefs.setStringList('chat_messages', messagesJson);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getStringList('chat_messages');
    if (messagesJson != null) {
      _messages.clear(); // Ensure we don't duplicate on load
      _messages.addAll(messagesJson
          .map((json) => ChatMessage.fromJson(jsonDecode(json)))
          .toList());
    }
  }
}
