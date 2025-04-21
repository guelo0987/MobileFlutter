import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Product.dart';
import 'env.dart';
import 'manage_http_response.dart';
import 'package:dartproyect/config/api_config.dart';

class ProductService {
  // Get all products
  static Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse(Environment.products),
        headers: Environment.headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> productsJson = responseData['products'] ?? [];

        final products =
            productsJson.map((json) => Product.fromJson(json)).toList();
        return products;
      } else {
        throw Exception(
            ManageHttpResponse.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      print('Error al obtener todos los productos: $e');
      return [];
    }
  }

  // Get popular products
  static Future<List<Product>> getPopularProducts() async {
    try {
      final response = await http.get(
        Uri.parse(Environment.popularProducts),
        headers: Environment.headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> productsJson = responseData['products'] ?? [];

        final products =
            productsJson.map((json) => Product.fromJson(json)).toList();
        return products;
      } else if (response.statusCode == 404) {
        // No popular products found
        return [];
      } else {
        throw Exception(
            ManageHttpResponse.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      print('Error al obtener productos populares: $e');
      return [];
    }
  }

  // Get recommended products
  static Future<List<Product>> getRecommendedProducts() async {
    try {
      final response = await http.get(
        Uri.parse(Environment.recommendedProducts),
        headers: Environment.headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> productsJson = responseData['products'] ?? [];

        final products =
            productsJson.map((json) => Product.fromJson(json)).toList();
        return products;
      } else if (response.statusCode == 404) {
        // No recommended products found
        return [];
      } else {
        throw Exception(
            ManageHttpResponse.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      print('Error al obtener productos recomendados: $e');
      return [];
    }
  }

  // Get product by id
  static Future<Product?> getProductById(String productId) async {
    try {
      final response = await http.get(
        Uri.parse(Environment.getProductById(productId)),
        headers: Environment.headers,
      );

      if (response.statusCode == 200) {
        final productJson = jsonDecode(response.body);
        return Product.fromJson(productJson);
      } else {
        throw Exception(
            ManageHttpResponse.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      print('Error al obtener producto por ID: $e');
      return null;
    }
  }

  static Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/products'),
      headers: ApiConfig.headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> products = data['products'];

      return products.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<Product>> getProductsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/products/category/$category'),
      headers: ApiConfig.headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> products = data['products'];

      return products.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }

  static Future<List<Product>> getProductsBySubCategory(
      String subcategory) async {
    try {
      final response = await http.get(
        Uri.parse('${Environment.products}?subCategory=$subcategory'),
        headers: Environment.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['products'] != null) {
          final List<dynamic> productsData = data['products'];
          return productsData
              .map((productData) => Product.fromJson(productData))
              .toList();
        }
      }

      print(
          'Error fetching products by subcategory: ${response.statusCode} - ${response.body}');
      return [];
    } catch (e) {
      print('Exception fetching products by subcategory: $e');
      return [];
    }
  }

  static Future<Product> getProductByIdLegacy(String id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/products/$id'),
      headers: ApiConfig.headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> productData = data['product'];

      return Product.fromJson(productData);
    } else {
      throw Exception('Failed to load product');
    }
  }

  static Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/products/search?q=$query'),
      headers: ApiConfig.headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> products = data['products'];

      return products.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }
}
