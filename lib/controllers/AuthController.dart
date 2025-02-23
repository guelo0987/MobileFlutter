import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/User.dart';
import '../services/manage_http_response.dart';
import '../services/env.dart';

class AuthController {
  Future<ApiResponse<AuthData>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Environment.register),
        headers: Environment.headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      return ManageHttpResponse.handleResponse<AuthData>(
        response: response,
        onSuccess: (json) => AuthData.fromJson(json),
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error de conexión: $e',
        statusCode: 500,
      );
    }
  }

  Future<ApiResponse<AuthData>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Environment.login),
        headers: Environment.headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return ManageHttpResponse.handleResponse<AuthData>(
        response: response,
        onSuccess: (json) => AuthData.fromJson(json),
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error de conexión: $e',
        statusCode: 500,
      );
    }
  }
}

class AuthData {
  final String message;
  final String? token;
  final User? user;

  AuthData({
    required this.message,
    this.token,
    this.user,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      message: json['message'] ?? '',
      token: json['token'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'token': token,
      'user': user?.toJson(),
    };
  }
}