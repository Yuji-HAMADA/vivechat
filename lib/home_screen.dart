
import 'package:flutter/material.dart';
import 'package:vivechat/character_selection_screen.dart';
import 'package:vivechat/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCharacter;

  void _onCharacterSelected(String character) {
    setState(() {
      _selectedCharacter = character;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _selectedCharacter == null
        ? CharacterSelectionScreen(onCharacterSelected: _onCharacterSelected)
        : ChatScreen(character: _selectedCharacter!);
  }
}
