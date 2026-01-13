import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stylex/models/productModel.dart';
import 'package:stylex/screens/Home/animation_categories.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylex/screens/Home/notifications.dart';
import 'package:stylex/screens/Home/search_screen.dart';
import 'package:stylex/screens/popular_items.dart';
import 'package:stylex/screens/product_details.dart';
import 'package:stylex/widgets/cartIcon.dart';
import 'package:stylex/widgets/navigation.dart';
import 'package:stylex/widgets/wishlistIcon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      

      appBar: AppBar(
       
        title: searchBar(context),

        actions: [
          IconButton(
            onPressed: () {
          navigation(context, Notificationscreen());
            },
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            tooltip: "Notifications",
          ),
        wishlist(context),
        cartIcon(context),
         
          const SizedBox(width: 8),
        ],
      ),

      body: shoppingHomeBody(),
    );
  }

 
  Widget searchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
       navigation(context, SearchScreen());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        child: Container(
          height: 35,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 1.5),
           
          ),
          child: Row(
            children: [
              const SizedBox(width: 15),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.deepOrange, size: 22),

                    Text(
                      "Search products",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget shoppingHomeBody() {
  return CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),

            SmoothCategoryCarousel(
              items: [
                CategoryItem(title: "tshirts", image: "assets/images/tshirts.webp"),
                CategoryItem(title: "Bags", image: "assets/images/bags.webp"),
                CategoryItem(title: "shoes", image: "assets/images/shoes.webp"),
                CategoryItem(title: "Watches", image: "assets/images/watches.webp"),
                CategoryItem(title: "Beauty", image: "assets/images/beauty.webp"),
                CategoryItem(title: "Electronics", image: "assets/images/electronics.webp"),
                CategoryItem(title: "Tops", image: "assets/images/tops.webp"),
                CategoryItem(title: "Sarees", image: "assets/images/sarees.webp"),
                CategoryItem(title: "Pants", image: "assets/images/pants.webp"),
                CategoryItem(title: "Skerts", image: "assets/images/skerts.webp"),
              ],
            ),

            _sectionTitle("TRENDING ITEMS", Alignment.center),
            SizedBox(height: 12),
          ],
        ),
      ),

     
      SliverToBoxAdapter(
     
        
        child: PopularItemsSection()
      ),

      // Suggested items section
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            _sectionTitle("SUGGESTED FOR YOU", Alignment.centerLeft),
            SizedBox(height: 12),
            _suggestedItems(),
          ],
        ),
      )
    ],
  );
}

Widget _sectionTitle(String text, AlignmentGeometry alignment) {
  return Align(
    alignment: alignment,
    child: Text(
      text,
      style: GoogleFonts.palanquin(fontSize: 22, fontWeight: FontWeight.w900),
    ),
  );
}

Widget _popularItems(List<Product> products, bool isLoading) {
  return SizedBox(
    height: 270, // Slightly increased to prevent overflow
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: isLoading ? 5 : products.length, // Show 5 skeletons if loading
      itemBuilder: (context, index) {
        if (isLoading) {
          return _buildShimmerPlaceholder();
        }

        final product = products[index];

        // Calculate dynamic discount
        double originalPrice = product.price.toDouble();
        double discountPrice = (product.offerPrice).toDouble();
        double discountPercent =
            originalPrice > 0
                ? ((originalPrice - discountPrice) / originalPrice) * 100
                : 0;

        return GestureDetector(
          onTap: () {
            navigation(context, ProductDetailsPage(product: product.toMap()));
          },
          child: Container(
            width: 180,
            margin: const EdgeInsets.only(right: 15, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border(
                left: BorderSide(color: Colors.black, width: 1),
                bottom: BorderSide(color: Colors.black, width: 1),
                top: BorderSide(color: Colors.black, width: 1),
                right: BorderSide(
                  color: Colors.black,
                  width: 3,
                ), // Your signature shadow border
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PRODUCT IMAGE FROM API
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(product.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // PRODUCT DETAILS FROM API
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "₹$discountPrice",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "₹$originalPrice",
                            style: const TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${discountPercent.toStringAsFixed(0)}% OFF",
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

// THE SHIMMER EFFECT
Widget _buildShimmerPlaceholder() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: 180,
      margin: const EdgeInsets.only(right: 15, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
    ),
  );
}

Widget _suggestedItems() {
  return GestureDetector(
    onTap: () {
      print('taped');
    },
    child: 
   Column(
    children: List.generate(4, (index) {
      return Container(
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
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: const DecorationImage(
                  image: AssetImage("assets/images/sarees.webp"),
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
                  const Text(
                    "Casual Shirt",
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
                      const Text(
                        "₹499",
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
                        child: const Text(
                          "20% OFF",
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
      );
    }),
   )
  );
}
