class Environment {
  static const String apiUrl =
      'http://localhost:3000/api'; // Para emulador Android
  // static const String apiUrl = 'http://localhost:3000/api';  // Para iOS

  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';

  // Endpoints constants
  static String get register => '$apiUrl$registerEndpoint';
  static String get login => '$apiUrl$loginEndpoint';

  // Headers
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Headers with token
  static Map<String, String> getAuthHeaders(String token) => {
        ...headers,
        'Authorization': 'Bearer $token',
      };
}
