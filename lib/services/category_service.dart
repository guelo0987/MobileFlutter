import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Category.dart';
import 'env.dart';
import 'manage_http_response.dart';

class CategoryService {
  // Get all categories
  static Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse(Environment.categories),
        headers: Environment.headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> categoriesJson = responseData['categories'] ?? [];

        final categories =
            categoriesJson.map((json) => Category.fromJson(json)).toList();
        return categories;
      } else {
        throw Exception(
            ManageHttpResponse.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      return [];
    }
  }
}
