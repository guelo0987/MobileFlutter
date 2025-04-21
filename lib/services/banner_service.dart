import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Banner.dart';
import 'env.dart';
import 'manage_http_response.dart';

class BannerService {
  // Get all banners
  static Future<List<Banner>> getBanners() async {
    try {
      final response = await http.get(
        Uri.parse(Environment.banner),
        headers: Environment.headers,
      );

      // Parse the response directly since we're expecting a list
      if (response.statusCode == 200) {
        final List<dynamic> bannersJson = jsonDecode(response.body);
        final banners =
            bannersJson.map((json) => Banner.fromJson(json)).toList();
        return banners;
      } else {
        throw Exception(
            ManageHttpResponse.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      // Return empty list if there's an error
      return [];
    }
  }
}
