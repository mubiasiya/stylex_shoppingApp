import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylex/bloc/cart_bloc.dart';
import 'package:stylex/bloc/wishlist_bloc.dart';
import 'package:stylex/models/productModel.dart';
import 'package:stylex/models/wishlistItemModel.dart';
import 'package:stylex/screens/Home/search_screen.dart';
import 'package:stylex/screens/cart_screen.dart';
import 'package:stylex/widgets/backbutton.dart';
import 'package:stylex/widgets/cartIcon.dart';
import 'package:stylex/widgets/navigation.dart';
import 'package:stylex/widgets/wishlistIcon.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    int original = product["price"];
    int offer = product["offerPrice"];
    double percent = ((original - offer) / original) * 100;

    return Scaffold(
      appBar: AppBar(
        leading: backArrow(context),
        actions: [
          IconButton(
            onPressed: () {
              navigation(context, SearchScreen());
            },
            icon: Icon(Icons.search, color: Colors.black),
            tooltip: 'Search items',
          ),
          wishlist(context),
          cartIcon(context),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 HERO IMAGE
            Hero(
              tag: product['id'],
              child: Container(
                height: 320,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Image.network(product['image'], fit: BoxFit.contain),
              ),
            ),

            const SizedBox(height: 10),

            /// PRODUCT INFO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    product['title'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product['description'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// PRICE ROW
                  Row(
                    children: [
                      Text(
                        "₹$offer",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "₹$original",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${percent.toStringAsFixed(0)}% OFF",
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.share),
                      SizedBox(width: 5),
                    ],
                  ),

                  const SizedBox(height: 6),
                  Text(
                    "Inclusive of all taxes",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 20),

                  /// SPECIFICATIONS
                  const Text(
                    "Product Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Column(
                    children:
                        product['specifications'].entries.map<Widget>((entry) {
                          return _specRow(
                            entry.key.toString(),
                            entry.value.toString(),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 90), // space for bottom bar
          ],
        ),
      ),

      bottomNavigationBar: _bottomBar(
        context,
        Product(
          id: product['id'],
          title: product['title'],
          price: product['price'],
          offerPrice: product['offerPrice'],
          image: product['image'],
          description: product['description'],
          category: product['category'],
          tags: product['tags'],
          specifications: product['specifications'],
        ),
      ),
    );
  }

  /// SPEC ITEM
  Widget _specRow(dynamic title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.black)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  /// BOTTOM BAR
  Widget _bottomBar(BuildContext context, Product product) {
    return Container(
      height: 70,

      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                // SizedBox(width: 20,),
                addtowishlistButton(
                  context,
                  WishlistItem(
                    productId: product.id,
                    title: product.title,
                    image: product.image,
                    originalPrice: product.price,
                    offerPrice: product.offerPrice,
                    addedAt: DateTime(2025),
                  ),
                ),
                SizedBox(width: 10),
                addtobagButton(context, product),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget addtobagButton(BuildContext context, Product product) {
  return BlocListener<CartBloc, CartState>(
    listenWhen:
        (previous, current) =>
            current.status == CartStatus.alreadyInCart ||
            current.status == CartStatus.success,

    listener: (context, state) {
      if (state.status == CartStatus.alreadyInCart) {
        _showSnackBar(
          context,
          "Item is already in your bag! so we have increased quantity by 1",
        );
      } else if (state.status == CartStatus.success) {
        _showSnackBar(context, "Added to bag successfully!");
      }
    },
    child: ElevatedButton(
      onPressed: () async {
        print('added');
        context.read<CartBloc>().add(AddToCart(product, 1));
      },

      style: ElevatedButton.styleFrom(
        fixedSize: const Size(170, 50),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        side: BorderSide(color: Colors.deepOrange),
      ),
      child: Row(
        children: [
          Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 22),
          SizedBox(width: 8),
          const Text(
            "ADD TO BAG",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ],
      ),
      // ),
    ),
  );
}

Widget addtowishlistButton(BuildContext context, WishlistItem item) {
  return ElevatedButton(
    onPressed: () {
      context.read<WishlistBloc>().add(ToggleWishlist(item));
      print('wishlisted');
    },
    style: ElevatedButton.styleFrom(
      fixedSize: const Size(170, 50),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      side: BorderSide(color: Colors.black),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.favorite_border_outlined, color: Colors.deepOrange),
        SizedBox(width: 7),
        const Text(
          "ADD TO LIST",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.deepOrange,
          ),
        ),
      ],
    ),
  );
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.deepOrange.withOpacity(0.7),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "VIEW CART",
        textColor: Colors.white,
        backgroundColor: Colors.black,
        onPressed: () {
          navigation(context, CartPage());
        },
      ),
    ),
  );
}
