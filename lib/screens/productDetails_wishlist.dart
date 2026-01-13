import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylex/bloc/cart_bloc.dart';
import 'package:stylex/bloc/wishlist_bloc.dart';
import 'package:stylex/models/productModel.dart';
import 'package:stylex/models/wishlistItemModel.dart';
import 'package:stylex/widgets/scaff_msg.dart';

class MyFullProductUI extends StatelessWidget {
  final Product product; 

  const MyFullProductUI({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Image Header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(product.image, fit: BoxFit.cover),
            ),
          ),

          // 2. Product Information
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price Row
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "₹${product.offerPrice}",
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "₹${product.price}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                 
                  Text(
                    product.description,
                    style: const TextStyle(color: Colors.black87, height: 1.5),
                  ),

                  const SizedBox(height: 24),

                  // Specifications Table
                  const Text(
                    "product Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildSpecTable(product.specifications),

                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomAction(context),
    );
  }

  Widget _buildSpecTable(Map<String, dynamic> specs) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children:
            specs.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        entry.key.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    Expanded(flex: 3, child: Text(entry.value.toString())),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Colors.orange[700],
        ),
        onPressed: () {
          context.read<CartBloc>().add(AddToCart(product, 1));
           context.read<WishlistBloc>().add(
            ToggleWishlist(
              WishlistItem(
                productId: product.id,
                title: product.title,
                image: product.image,
                originalPrice: product.price,
                offerPrice: product.offerPrice,
                addedAt: DateTime(2025),
              ),
            ),
          );
          Navigator.pop(context);
          
          message(context, 'Successfully added to bag');
        },
        child: const Text(
          "ADD TO BAG",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
