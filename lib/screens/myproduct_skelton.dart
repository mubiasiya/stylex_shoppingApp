import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stylex/models/wishlistItemModel.dart';

class MyProductSkeleton extends StatelessWidget {
  final WishlistItem? initialData; // Data passed from Wishlist/Cart

  const MyProductSkeleton({super.key, this.initialData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
          initialData?.image != null
              ? Image.network(
                initialData!.image,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              )
              : _buildShimmerBox(height: 300, width: double.infinity),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Title Area
                initialData?.title != null
                    ? Text(
                      initialData!.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    : _buildShimmerBox(height: 25, width: 200),

                const SizedBox(height: 10),

                // Price Area
                initialData?.offerPrice != null
                    ? Text(
                      "₹${initialData!.offerPrice}",
                      style: const TextStyle(fontSize: 18, color: Colors.deepOrange),
                    )
                    : _buildShimmerBox(height: 20, width: 80),

                const SizedBox(height: 30),
                const Divider(),
                //  Description Shimmer 
                const Text(
                  "Product Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildShimmerBox(height: 15, width: double.infinity),
                const SizedBox(height: 5),
                _buildShimmerBox(height: 15, width: double.infinity),
                const SizedBox(height: 5),
                _buildShimmerBox(height: 15, width: 150),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create the shimmering effect
  Widget _buildShimmerBox({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
