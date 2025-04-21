import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/User.dart';
import 'env.dart';
import 'manage_http_response.dart';

class UserService {
  // Get current user data
  static Future<User?> getCurrentUser() async {
    try {
      // Obtener el token y datos del usuario de las preferencias compartidas
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userData = prefs.getString('user_data');

      if (token == null) {
        return null; // No hay token, no hay usuario actual
      }

      // Si tenemos datos de usuario guardados, los usamos
      if (userData != null) {
        try {
          final userMap = jsonDecode(userData);
          return User.fromJson(userMap);
        } catch (e) {
          print('Error al decodificar datos de usuario: $e');
        }
      }

      // Si no tenemos datos guardados, intentamos obtenerlos del servidor
      // Esta parte probablemente no funcione en tu caso, pero la dejamos por si acaso
      final response = await http.get(
        Uri.parse(Environment.currentUser),
        headers: Environment.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return User.fromJson(userData);
      } else if (response.statusCode == 401) {
        // Token inválido o expirado, limpiar token
        await prefs.remove('token');
        await prefs.remove('user_data');
        return null;
      } else {
        throw Exception(
            ManageHttpResponse.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      print('Error en getCurrentUser: $e');
      return null;
    }
  }

  // Guardar token y datos de usuario en SharedPreferences
  static Future<void> saveToken(
      String token, Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);

    // También guardamos los datos del usuario
    if (userData.isNotEmpty) {
      await prefs.setString('user_data', jsonEncode(userData));
    }
  }

  // Obtener token de SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Limpiar token y datos de usuario (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
