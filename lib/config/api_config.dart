class ApiConfig {
  static const String baseUrl =
      'https://api.example.com/v1'; // Reemplazar con la URL real de la API

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Agregar configuración para token de autenticación
  static Map<String, String> getAuthHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
