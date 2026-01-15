import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stylex/models/productModel.dart';
import 'package:stylex/screens/product_details.dart';
import 'package:stylex/services/api/suggestApi.dart';
import 'package:stylex/widgets/navigation.dart';

Widget buildSuggestedSection() {
  return FutureBuilder<List<Product>>(
    future: getSuggestions(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _suggestedItemsShimmer();
      } else if (snapshot.hasError ||
          !snapshot.hasData ||
          snapshot.data!.isEmpty) {
        return const Center(child: Text("No suggestions found"));
      }

      final products = snapshot.data!;

      return Column(
        children:
            products.map((product) => _buildProductItem(product,context)).toList(),
      );
    },
  );
}

//
Widget _buildProductItem(Product product,BuildContext context){
  int original = product.price;
  int offer = product.offerPrice;
  double percent = ((original - offer) / original) * 100;
  return GestureDetector(
    onTap: (){
      navigation(context, ProductDetailsPage(product: product.toMap()));
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 18),
    
      padding: const EdgeInsets.all(14),
    
      decoration: BoxDecoration(
        color: Colors.white,
    
        borderRadius: BorderRadius.circular(16),
    
        border: Border(
          bottom: BorderSide(
            color: Colors.black, // bottom border black
    
            width: 1.2,
          ),
        ),
    
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
    
            blurRadius: 8,
    
            offset: const Offset(0, 3),
          ),
        ],
      ),
    
      child: Row(
        children: [
          // PRODUCT IMAGE WITH GRADIENT OVERLAY
          Container(
            height: 110,
    
            width: 130,
    
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
    
              image: DecorationImage(
                image: NetworkImage(product.image),
    
                fit: BoxFit.cover,
              ),
    
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.2),
    
                  blurRadius: 10,
    
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
    
          const SizedBox(width: 14),
    
          // TEXTS + SUBTITLE + BADGE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
    
              children: [
                // TITLE
                Text(
                  product.title,
    
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
    
                  style: TextStyle(
                    fontSize: 17,
    
                    fontWeight: FontWeight.bold,
    
                    color: Colors.black87,
                  ),
                ),
    
                const SizedBox(height: 4),
    
                // SMALL SUBTEXT
                Text(
                  "High quality | Best price",
    
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
    
                const SizedBox(height: 8),
    
                // PRICE + BADGE
                Row(
                  children: [
                    Text(
                      product.price.toString(),
                      style: TextStyle(
                        fontSize: 17,
    
                        fontWeight: FontWeight.w700,
    
                        color: Colors.black,
                      ),
                    ),
    
                    const SizedBox(width: 8),
    
                    // BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
    
                        horizontal: 8,
                      ),
    
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
    
                        borderRadius: BorderRadius.circular(12),
                      ),
    
                      child: Text(
                        '${percent.toInt().toString()}% OFF',
    
                        style: TextStyle(
                          fontSize: 11,
    
                          color: Colors.deepOrange,
    
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _suggestedItemsShimmer() {
  return Column(
    children: List.generate(4, (index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Image Placeholder
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Placeholder
                    Container(width: 120, height: 16, color: Colors.white),
                    const SizedBox(height: 8),
                    // Subtitle Placeholder
                    Container(width: 80, height: 12, color: Colors.white),
                    const SizedBox(height: 12),
                    // Price Placeholder
                    Container(width: 50, height: 16, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }),
  );
}
