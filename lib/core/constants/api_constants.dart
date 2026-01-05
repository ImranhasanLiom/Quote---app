class ApiConstants {
  static const String baseUrl = 'https://zenquotes.io/api';
  static const String randomQuote = '$baseUrl/random';
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const Duration connectTimeout = Duration(seconds: 10);
}