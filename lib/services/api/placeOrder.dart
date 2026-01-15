import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylex/models/cartItemModel.dart';

Future<bool> placeOrder({
  required List<CartItem> cartItems,
  required String address,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString('firebase_uid');

  final orderData = {
    "userId": uid,
    "cartItems":
        cartItems
            .map(
              (item) => {
                "productId": item.productId,
                "title": item.title,
                "price": item.price,
                "quantity": item.qty,
                "image": item.image,
              },
            )
            .toList(),
    "shippingAddress": address,
  };

  try {
    final response = await http.post(
      Uri.parse(
        'https://shopapp-server-dnq1.onrender.com/api/order/create-order',
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 201) {
      print("Order Created: ${response.body}");
      return true; // Success!
    } else {
      print("Server Error: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Network Error: $e");
    return false;
  }
}
