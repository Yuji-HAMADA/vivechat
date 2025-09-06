import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vivechat/auth_service.dart';
import 'package:vivechat/home_screen.dart';
import 'package:vivechat/pass_key_screen.dart';
import 'package:vivechat/generated/app_localizations.dart';
import 'package:vivechat/locale_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: Consumer<LocaleProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            locale: provider.locale,
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const InitialScreen(),
          );
        },
      ),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  InitialScreenState createState() => InitialScreenState();
}

class InitialScreenState extends State<InitialScreen> {
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

