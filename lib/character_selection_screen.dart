
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CharacterSelectionScreen extends StatefulWidget {
  final Function(String) onCharacterSelected;

  CharacterSelectionScreen({required this.onCharacterSelected});

  @override
  _CharacterSelectionScreenState createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _selectFromDevice() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      widget.onCharacterSelected(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Character'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                widget.onCharacterSelected('assets/female.png');
              },
              child: Image.asset('assets/female.png', width: 150, height: 150),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                widget.onCharacterSelected('assets/male.png');
              },
              child: Image.asset('assets/male.png', width: 150, height: 150),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectFromDevice,
              child: Text('Select from Device'),
            ),
          ],
        ),
      ),
    );
  }
}
