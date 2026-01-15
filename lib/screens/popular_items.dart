
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stylex/models/productModel.dart';
import 'package:stylex/screens/product_details.dart';
import 'package:stylex/widgets/navigation.dart';

class PopularItemsSection extends StatefulWidget {
  const PopularItemsSection({super.key});

  @override
  State<PopularItemsSection> createState() => _PopularItemsSectionState();
}

class _PopularItemsSectionState extends State<PopularItemsSection> {
  
  Future<List<Product>> fetchTrendingProducts() async {
    try {
      final response = await Dio().get(
        'https://shopapp-server-dnq1.onrender.com/api/popitems/products/trending',
      );
    //  if (response.data != null) {
        
    //    final decoded = json.decode(response.data);

    //     final List list = decoded['products'];

    //     return list.map((e) => Product.fromJson(e)).toList();
     
    //   }

    //   return response.data; 
    // Dio already decodes JSON, so response.data is likely a Map
      if (response.data != null) {
       
        final List list = response.data;

        return list.map((e) => Product.fromJson(e)).toList();
      } else {
        return []; // Return empty list instead of null if data is missing
      }
    } catch (e) {
      print("API Error: $e");
      throw Exception("Failed to load products");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder <List<Product>>(
      future: fetchTrendingProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // SHOW SHIMMER WHILE LOADING
          return _buildPopularList(isLoading: true, data: []);
        } else if (snapshot.hasError) {
          // 2. SHOW ERROR STATE
          return const Center(child: Text("Couldn't load items"));
        } else {
          // 3. SHOW REAL DATA
          return _buildPopularList(isLoading: false, data: snapshot.data ?? []);
        }
      },
    );
  }

  Widget _buildPopularList({
    required bool isLoading,
    required  List<Product> data,
  }) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: isLoading ? 5 : data.length,
        itemBuilder: (context, index) {
          if (isLoading) return _buildShimmerCard();

          final item = data[index];
          double original = (item.price ).toDouble();
          double offer = (item.offerPrice).toDouble();
          int discount =
              original > 0
                  ? (((original - offer) / original) * 100).round()
                  : 0;

          return _productCard(item, original, offer, discount, item);
        },
      ),
    );
  }

  Widget _productCard(item, original, offer, discount,Product items) {
    return GestureDetector(
      onTap: () {
        navigation(context, ProductDetailsPage(product: items.toMap()));
      },
      child: Container(
        width: 200,
        // height: 400,
        margin: const EdgeInsets.only(right: 15, bottom: 10, top: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: const Border(
            left: BorderSide(color: Colors.black, width: 1),
            bottom: BorderSide(color: Colors.black, width: 1),
            top: BorderSide(color: Colors.black, width: 1),
            right: BorderSide(color: Colors.black, width: 3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(item.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Details Section
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "₹$offer",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "₹$original",
                        style: const TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "$discount% OFF",
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 15, bottom: 10, top: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}
