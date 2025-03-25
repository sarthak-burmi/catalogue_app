import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../models/product_model.dart';

class ProductService {
  Future<List<Product>> fetchProducts(int page, {int limit = 30}) async {
    final response = await http.get(
      Uri.parse(
          'https://dummyjson.com/products?limit=$limit&skip=${(page - 1) * limit}'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> productsJson = data['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}

// Add this provider
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});
