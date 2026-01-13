import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stylex/models/productModel.dart';

class SearchApi {
  static const String baseUrl = "https://shopapp-server-dnq1.onrender.com";

  static Future<List<Product>> searchProducts({required String query}) async {
    final url = Uri.parse("$baseUrl/Search?keyword=$query");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      final List list = decoded['products'];

      return list.map((e) => Product.fromJson(e)).toList();
    }
    else if(response.statusCode==404){
     return [];
    }
     else {
      throw Exception("Failed to load products");
    }
  }
}
