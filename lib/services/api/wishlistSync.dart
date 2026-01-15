import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:stylex/models/HiveModelWishlist.dart';

Future<void> syncHiveWishlistToBackend(String firebaseUid) async {
  var box = Hive.box< WishlistItemHive>('wishlist_box');

  final allItems = box.values.toList();

  List wishlistData =
      allItems
          .map((item) => item.productId, )
          .toList();

  try {
    final response = await http
        .post(
          Uri.parse(
            'https://shopapp-server-dnq1.onrender.com/api/wishlistSync/sync-wishlist',
          ),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"firebaseUid": firebaseUid, "wishlistItems": wishlistData}),
        )
        .timeout(const Duration(seconds: 15));


        print(response.statusCode);

    if (response.statusCode == 200) {
    //   for (var item in allItems) {
    //     if (!item.synced) {
    //       item.synced = true;
    //       await box.put(item.productId, item);
    //     }
      print('--- Cloud Sync Successful ---!!');
      }
      else{
        print('something happended');
        print(response.body);
      }
    
    
  } catch (e) {
    print("Sync Failed: $e (Will retry next time user is online)");
  }
}
