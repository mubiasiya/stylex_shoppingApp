import 'package:hive/hive.dart';

part 'HiveModelWishlist.g.dart'; // Run build_runner to generate this

@HiveType(typeId: 2) // Ensure typeId is unique (Cart was likely 1)
class WishlistItemHive extends HiveObject {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final int originalPrice;

  @HiveField(4)
  final int offerPrice;

  @HiveField(5)
  final DateTime addedAt;

  WishlistItemHive({
    required this.productId,
    required this.title,
    required this.image,
    required this.originalPrice,
    required this.offerPrice,
    required this.addedAt,
  });
}
