import 'package:stylex/models/HiveModelWishlist.dart';
import 'package:stylex/models/wishlistItemModel.dart';
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
    // Add background cloud sync call here if needed
  }

  Future<void> removeFromWishlist(String productId) async {
    await localService.removeFromWishlist(productId);
    // Add background cloud sync call here if needed
  }
}
