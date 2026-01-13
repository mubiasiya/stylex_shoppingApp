class Product {
  final String id;
  final String title;
  final int price;
  final int offerPrice;
  final String image;
  final String description;
  final String category;
  final List<String> tags;

  final Map<String, dynamic> specifications;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.offerPrice,
    required this.image,
    required this.description,
    required this.category,
    required this.tags,
    required this.specifications,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? json['_id'] ?? 0, 
      title: json['title'],
      price: json['price'],
      offerPrice: json['offerPrice'],
      image: json['image'],
      description: json['description'],
      category: json['category'],
      tags: List<String>.from(json['tags']),
      specifications: Map<String, dynamic>.from(json['specifications']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "offerPrice": offerPrice,
      "image": image,
      "description": description,
      "category": category,
      "tags": tags,
      "specifications": specifications,
    };
  }
}
