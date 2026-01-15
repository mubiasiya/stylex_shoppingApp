import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylex/models/HiveModelWishlist.dart';
import 'package:stylex/models/wishlistItemModel.dart';
import 'package:stylex/services/api/wishlistSync.dart';
import 'package:stylex/services/hive/wishlist_service.dart';

class WishlistRepository {
  final WishlistLocalService localService;

  WishlistRepository(this.localService);

  // Load and convert Hive Models to BLoC Models
  Future<List<WishlistItem>> getWishlist() async {
    final localItems = await localService.getAllWishlistItems();
    return localItems
        .map(
          (hiveItem) => WishlistItem(
            productId: hiveItem.productId,
            title: hiveItem.title,
            image: hiveItem.image,
            originalPrice: hiveItem.originalPrice,
            offerPrice: hiveItem.offerPrice,
            addedAt: hiveItem.addedAt,
          ),
        )
        .toList();
  }

  Future<void> addToWishlist(WishlistItem item) async {
    final hiveItem = WishlistItemHive(
      productId: item.productId,
      title: item.title,
      image: item.image,
      originalPrice: item.originalPrice,
      offerPrice: item.offerPrice,
      addedAt: item.addedAt,
    );
    await localService.saveToWishlist(hiveItem);
   
    _attemptSync();
  }

  Future<void> removeFromWishlist(String productId) async {
    await localService.removeFromWishlist(productId);
    
    _attemptSync();
  }

   Future<void> _attemptSync() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('firebase_uid');

    if (uid != null) {
      await syncHiveWishlistToBackend(uid);
    }
  }
}
