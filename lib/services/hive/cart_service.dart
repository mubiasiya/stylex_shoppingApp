// import 'package:hive/hive.dart';
// import 'package:stylex/models/HiveModelCart.dart';
// import 'package:stylex/models/cartItemModel.dart';

// class CartLocalService {
//   static const String boxName = 'cartBox';

//   Future<Box<CartItemHive>> _box() async =>
//       await Hive.openBox<CartItemHive>(boxName);

//   Future<List<CartItem>> getItems() async {
//     final box = await _box();
//     return box.values.map((e) {
//       return CartItem(
//         productId: e.productId,
//         title: e.title,
//         image: e.image,
//         price: e.price,
//         qty: e.qty,
//         selected: e.selected,
//         synced: e.synced,
//       );
//     }).toList();
//   }

//   Future<void> saveItems(List<CartItem> items) async {
//     final box = await _box();
//     await box.clear();

//     for (final item in items) {
//       await box.put(
//          item.productId,
//         CartItemHive(
//           productId: item.productId,
//           title: item.title,
//           image: item.image,
//           price: item.price,
//           qty: item.qty,
//           selected: item.selected,
//           synced: item.synced,
//         ),
//       );
//     }
//   }

//   Future<void> removeItem(String productId) async {
//      final box = await _box();
//     await box.delete(productId);
//   }

//   Future<void> updateQty(String productId, int qty) async {
//      final box = await _box();
//     final item = box.get(productId);
//     if (item != null) {
//       item.qty = qty;
//       await item.save();
//     }
//   }

//   Future<void> toggleSelection(String productId) async {
//      final box = await _box();
//   final item = box.get(productId);
//   if (item != null) {
//     item.selected = !item.selected;
//     await item.save();
//   }
// }



// }
import 'package:hive/hive.dart';
import 'package:stylex/models/HiveModelCart.dart';
import 'package:stylex/models/cartItemModel.dart';

class CartLocalService {
  static const String boxName = 'cartBox';

  
  Future<Box<CartItemHive>> _getBox() async {
    return Hive.isBoxOpen(boxName) 
        ? Hive.box<CartItemHive>(boxName) 
        : await Hive.openBox<CartItemHive>(boxName);
  }

  // 1. Get All Items (Mapped to UI Model)
  Future<List<CartItem>> getItems() async {
    final box = await _getBox();
    return box.values.map((e) {
      return CartItem(
        productId: e.productId,
        title: e.title,
        image: e.image,
        price: e.price,
        qty: e.qty,
        selected: e.selected,
        synced: e.synced,
      );
    }).toList();
  }
  

  // 2. Save or Update a Single Item (The "Pro" Way)
  Future<void> saveItem(CartItem item) async {
    final box = await _getBox();
    
    
    
    final itemToSave = CartItemHive(
      productId: item.productId,
      title: item.title,
      image: item.image,
      price: item.price,
      qty:  item.qty,
      selected: item.selected,
      synced: false, // Always mark as false so the Repository triggers a sync
    );

    await box.put(item.productId, itemToSave);
  }

  // 3. Remove Single Item
  Future<void> removeItem(String productId) async {
    final box = await _getBox();
    await box.delete(productId);
  }

  // 4. Update Quantity directly
  Future<void> updateQty(String productId, int qty) async {
    final box = await _getBox();
    final item = box.get(productId);
    if (item != null) {
      item.qty = qty;
      item.synced = false; // Mark for re-sync
      await box.put(productId, item);
    }
  }

 
  Future<void> toggleSelection(String productId) async {
    final box = await _getBox();
    final item = box.get(productId);
    if (item != null) {
      item.selected = !item.selected;
      await box.put(productId, item); 
    }
  }
  

  /// Overwrites the local cart with a new list (used after removing selected items)
  Future<void> saveRemainingItems(List<CartItem> remainingItems) async {
    final box = await _getBox();
    
    // 1. Clear the box to remove all old entries
    await box.clear();

    // 2. If there are no items left, we stop here
    if (remainingItems.isEmpty) return;

    // 3. Convert UI models back to Hive models and save them all at once
    final Map<String, CartItemHive> newEntries = {
      for (var item in remainingItems)
        item.productId: CartItemHive(
          productId: item.productId,
          title: item.title,
          image: item.image,
          price: item.price,
          qty: item.qty,
          selected: item.selected,
          synced: false, // Mark as false so the backend syncs the deletion
        )
    };

    await box.putAll(newEntries);
  }
 
  Future<void> clearAll() async {
    final box = await _getBox();
    await box.clear();
  }
}
