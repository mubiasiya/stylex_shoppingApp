import 'package:stylex/services/api/cartSync.dart';
import 'package:stylex/services/hive/cart_service.dart';
// import 'package:stylex/services/api/sync_service.dart'; // Your syncHiveCartToBackend file
import 'package:stylex/models/cartItemModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  final CartLocalService localService;

  CartRepository({required this.localService});

  // 1. Unified Add/Update
  Future<void> addItem(CartItem item) async {
    // Write to Hive First
    await localService.saveItem(item);

    // Trigger background sync (Don't await, let it be background)
    _attemptSync();
  }

  // 2. Unified Remove
  Future<void> removeItem(String productId) async {
    // Remove from Hive
    await localService.removeItem(productId);

    _attemptSync();
  }

  Future<void> updateQuantity(String productId, int newQty) async {
    await localService.updateQty(productId, newQty);

    _attemptSync();
  }

  Future<void> clearSelectedItems(List<CartItem> remainingItems) async {
    // 1. Update Hive: Overwrite the box with only the items we want to keep
    await localService.saveRemainingItems(remainingItems);

    _attemptSync();
  }

  Future<void> _attemptSync() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('firebase_uid');

    if (uid != null) {
      await syncHiveCartToBackend(uid);
    }
  }

  // 4. Load Cart (From Local)
  Future<List<CartItem>> loadCart() async {
    return await localService.getItems();
  }
}
