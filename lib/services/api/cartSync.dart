import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:stylex/models/HiveModelCart.dart';

Future<void> syncHiveCartToBackend(String firebaseUid) async {
  var box = Hive.box<CartItemHive>('cartBox');

  
  final allItems = box.values.toList();

  
  List cartData =
      allItems
          .map((item) => {"productId": item.productId, "quantity": item.qty})
          .toList();

  try {
    final response = await http
        .post(
          Uri.parse(
            'https://shopapp-server-dnq1.onrender.com/api/cartSync/sync-cart',
          ),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"firebaseUid": firebaseUid, "cartItems": cartData}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      for (var item in allItems) {
        if (!item.synced) {
          item.synced = true;
          await box.put(item.productId, item);
        }
      }
      print('--- Cloud Sync Successful ---');
    }
  } catch (e) {
    print("Sync Failed: $e (Will retry next time user is online)");
  }
}
