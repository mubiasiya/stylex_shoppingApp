import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylex/models/productModel.dart';

// Fetching the suggestions
Future<List<Product>> getSuggestions() async {
  final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString('firebase_uid');

  try {
    final response = await http.get(
      Uri.parse(
        'https://shopapp-server-dnq1.onrender.com/api/suggestions/$uid',
      ),
    );
   
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['products'];
      return data.map((json) => Product.fromJson(json)).toList();
    }
    return [];
  } catch (e) {
    print('something');
    print(e.toString());
    return [];
  }
}
