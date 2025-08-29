class ApiConstants {
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/';
  static const String model = 'gemini-2.5-flash-image-preview';

  static String getEndpoint(String method) {
    return '$baseUrl$model:$method';
  }
}
