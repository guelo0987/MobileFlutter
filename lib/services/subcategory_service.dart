import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/SubCategory.dart';
import 'env.dart';
import 'manage_http_response.dart';

class SubCategoryService {
  // Get subcategories by category name
  static Future<List<SubCategory>> getSubCategories(String categoryName) async {
    try {
      final response = await http.get(
        Uri.parse(Environment.getSubcategoriesByCategoryName(categoryName)),
        headers: Environment.headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> subCategoriesJson =
            responseData['subcategories'] ?? [];

        final subCategories = subCategoriesJson
            .map((json) => SubCategory.fromJson(json))
            .toList();
        return subCategories;
      } else if (response.statusCode == 404) {
        // No subcategories found for this category
        return [];
      } else {
        throw Exception(
            ManageHttpResponse.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      return [];
    }
  }
}
