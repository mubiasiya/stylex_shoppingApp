class WishlistItem {
  final String productId;
  final String title;
  final String image;
  final int originalPrice;
  final int offerPrice;
  final DateTime addedAt;

  WishlistItem({
    required this.productId,
    required this.title,
    required this.image,
    required this.originalPrice,
    required this.offerPrice,
    required this.addedAt,
  });

  int get discountPercentage {
    if (originalPrice <= 0) return 0;
    return (((originalPrice - offerPrice) / originalPrice) * 100).round();
  }
}
