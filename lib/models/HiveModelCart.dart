import 'package:hive/hive.dart';

part 'HiveModelCart.g.dart';


@HiveType(typeId: 1)
class CartItemHive extends HiveObject {
  @HiveField(0)
  String productId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String image;

  @HiveField(3)
  int price;

  @HiveField(4)
  int qty;

  @HiveField(5)
  bool selected; 

  @HiveField(6)
  bool synced;

  CartItemHive({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.qty,
    required this.selected,
    required this.synced,
  });
}
