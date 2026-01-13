import 'package:hive/hive.dart';
import 'package:stylex/models/HiveModelWishlist.dart';

class WishlistLocalService {
  static const String _boxName = 'wishlist_box';

  // Open the box
  Future<Box<WishlistItemHive>> _getBox() async {
    return await Hive.openBox<WishlistItemHive>(_boxName);
  }

  // Save item to Wishlist
  Future<void> saveToWishlist(WishlistItemHive item) async {
    final box = await _getBox();
    await box.put(item.productId, item);
  }

  // Remove item from Wishlist
  Future<void> removeFromWishlist(String productId) async {
    final box = await _getBox();
    await box.delete(productId);
  }

  // Get all wishlist items
  Future<List<WishlistItemHive>> getAllWishlistItems() async {
    final box = await _getBox();
    return box.values.toList();
  }

  // Clear Wishlist (e.g., on Logout)
  Future<void> clearWishlist() async {
    final box = await _getBox();
    await box.clear();
  }
}
