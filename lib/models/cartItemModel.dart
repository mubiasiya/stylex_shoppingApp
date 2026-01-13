class CartItem {
  final String productId;
  final String title;
  final String image;
  final int price;
  final int qty;

  final bool selected; 
  final bool synced;   

  CartItem({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.qty,
    this.selected = false, 
    this.synced = false,
  });

  CartItem copyWith({
    int? qty,
    bool? selected,
    bool? synced,
  }) {
    return CartItem(
      productId: productId,
      title: title,
      image: image,
      price: price,
      qty: qty ?? this.qty,
      selected: selected ?? this.selected,
      synced: synced ?? this.synced,
    );
  }

  /// 🔥 LOCAL DB (Hive)
  Map<String, dynamic> toLocalJson() {
    return {
      'productId': productId,
      'title': title,
      'image': image,
      'price': price,
      'qty': qty,
      'selected': selected,
      'synced': synced,
    };
  }

  /// 🔥 API / MongoDB (NO selected field)
  Map<String, dynamic> toApiJson() {
    return {
      'productId': productId,
      'qty': qty,
    };
  }

  factory CartItem.fromLocalJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      title: json['title'],
      image: json['image'],
      price: json['price'],
      qty: json['qty'],
      selected: json['selected'] ?? true,
      synced: json['synced'] ?? false,
    );
  }

  @override
  String toString() {
    return 'CartItem(id: $productId, qty: $qty, selected: $selected)';
  }
}
