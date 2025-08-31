class ApiConstants {
  static const String baseUrl = 'https://us-central1-vivechat-40b60.cloudfunctions.net/geminiProxy';

  static String getEndpoint(String method) {
    // The method is now part of the proxy URL, so we just return the base URL.
    // The proxy will append the model and method itself.
    return baseUrl;
  }
}
