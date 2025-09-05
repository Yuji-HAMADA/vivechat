
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivechat/api_constants.dart';

class AuthService {
  static const _passKey = 'pass_key';

  Future<bool> validatePassKey(String passKey) async {
    final url = Uri.parse(ApiConstants.validatePassKeyUrl);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'pass_key': passKey});

    try {
      final response = await http.post(url, headers: headers, body: body);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> savePassKey(String passKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_passKey, passKey);
  }

  Future<String?> getPassKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passKey);
  }
}
