import 'package:flutter/material.dart';
import 'package:vivechat/auth_service.dart';
import 'package:vivechat/home_screen.dart';
import 'package:vivechat/pass_key_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vivechat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InitialScreen(),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final AuthService _authService = AuthService();
  late Future<String?> _passKeyFuture;

  @override
  void initState() {
    super.initState();
    _passKeyFuture = _authService.getPassKey();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _passKeyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return const HomeScreen();
        } else {
          return const PassKeyScreen();
        }
      },
    );
  }
}
