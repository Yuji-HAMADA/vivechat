
import 'package:flutter/material.dart';
import 'package:vivechat/auth_service.dart';
import 'package:vivechat/home_screen.dart';

class PassKeyScreen extends StatefulWidget {
  const PassKeyScreen({super.key});

  @override
  _PassKeyScreenState createState() => _PassKeyScreenState();
}

class _PassKeyScreenState extends State<PassKeyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passKeyController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _errorText;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorText = null;
      });

      final isValid = await _authService.validatePassKey(_passKeyController.text);

      if (isValid) {
        await _authService.savePassKey(_passKeyController.text);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        setState(() {
          _errorText = 'Invalid pass key';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Pass Key'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _passKeyController,
                decoration: InputDecoration(
                  labelText: 'Pass Key',
                  errorText: _errorText,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a pass key';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Continue'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
