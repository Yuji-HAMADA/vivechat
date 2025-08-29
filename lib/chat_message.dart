import 'dart:convert';

class ChatMessage {
  String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});

  Map<String, dynamic> toJson() => {'text': text, 'isUser': isUser};
  
  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      ChatMessage(text: json['text'], isUser: json['isUser']);
}
