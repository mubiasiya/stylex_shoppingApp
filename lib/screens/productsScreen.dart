import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylex/bloc/wishlist_bloc.dart';
import 'package:stylex/models/wishlistItemModel.dart';
import 'package:stylex/screens/Home/search_screen.dart';
import 'package:stylex/screens/product_details.dart';
import 'package:stylex/services/api/searchApi.dart';
import 'package:stylex/services/api/viewtrackApi.dart';
import 'package:stylex/widgets/backbutton.dart';
import 'package:stylex/widgets/cartIcon.dart';
import 'package:stylex/widgets/navigation.dart';
import 'package:stylex/widgets/title.dart';
import 'package:stylex/widgets/wishlistIcon.dart';
import 'package:stylex/models/productModel.dart';

class productsPage extends StatefulWidget {
  final String search;
  const productsPage({super.key, required this.search});

  @override
  State<productsPage> createState() => _productsPageState();
}

class _productsPageState extends State<productsPage> {
  Future<List<Product>>? products;
  bool hasProducts = false;

  void getproduct() async {
    Future<List<Product>> products1 = SearchApi.searchProducts(
      query: widget.search,
    );
    setState(() {
      products = products1;
    });
  }

  @override
  void initState() {
    super.initState();
    getproduct();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.search);
    return Scaffold(
      appBar: AppBar(
        leading: backArrow(context),
        title: title(widget.search),
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
      body: FutureBuilder(
        future: products,
        builder: (context, snapshot) {
          //loading

          if (snapshot.connectionState == ConnectionState.waiting) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (hasProducts != false) setState(() => hasProducts = false);
            });
            return Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange.withOpacity(0.7),
              ),
            );
          }

          // Error
          if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (hasProducts != false) setState(() => hasProducts = false);
            });
            return Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
            );
          }

          // No data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (hasProducts != false) setState(() => hasProducts = false);
            });
            return const Center(
              child: Text(
                "No products found",
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
            );
          }

          //products

          final products = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (hasProducts != true) setState(() => hasProducts = true);
          });
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.70,
            ),
            itemBuilder: (context, index) {
              return ProductCard(item: products[index].toMap());
            },
          );
        },
      ),

      bottomNavigationBar:hasProducts? bottom(context):null,
    );
  }
}

// ignore: must_be_immutable
class ProductCard extends StatelessWidget {
  Map<String, dynamic> item;
  ProductCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isFavorite = context.select(
      (WishlistBloc bloc) => bloc.state.wishlistIds.contains(item['id']),
    );
    int original = item["price"];
    int offer = item["offerPrice"];
    double percent = ((original - offer) / original) * 100;
    return GestureDetector(
      onTap: () {
        navigation(context, ProductDetailsPage(product: item));
        trackUserInterest(item['category']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Hero(
                  tag: item['id'],
                  child: Image.network(
                    item["image"],
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // // CONTENT
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE + FAVORITE
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item["title"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<WishlistBloc>().add(
                              ToggleWishlist(
                                WishlistItem(
                                  productId: item['id'],
                                  title: item["title"],
                                  image: item["image"],
                                  originalPrice: item["price"],
                                  offerPrice: item["offerPrice"],
                                  addedAt: DateTime(2025),
                                ),
                              ),
                            );
                            print('wishlisted');
                          },
                          child: TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 200),
                            tween: Tween<double>(
                              begin: 1.0,
                              end: isFavorite ? 1.2 : 1.0,
                            ),
                            builder: (context, double scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.black,
                                ),
                              );
                            },
                          ), 
                         
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // PRICE
                    Row(
                      children: [
                        Text(
                          "₹${original.toStringAsFixed(0)}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "₹${offer.toStringAsFixed(0)}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // OFFER %
                    Text(
                      "(${percent.toStringAsFixed(0)}% OFF)",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget bottom(BuildContext context) {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: Offset(0, -2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => showFilterSheet(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.filter_list, color: Colors.black),
                SizedBox(width: 6),
                Text("Filter", style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ),
        VerticalDivider(width: 1),
        Expanded(
          child: InkWell(
            onTap: () => showSortSheet(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.sort, color: Colors.black),
                SizedBox(width: 6),
                Text("Sort", style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

void showFilterSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Filter",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: true,
              onChanged: (_) {},
              title: const Text("Under ₹500"),
            ),
            CheckboxListTile(
              value: false,
              onChanged: (_) {},
              title: const Text("₹500 - ₹1000"),
            ),
            CheckboxListTile(
              value: false,
              onChanged: (_) {},
              title: const Text("Above ₹1000"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Apply", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    },
  );
}

void showSortSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Price: Low to High"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Price: High to Low"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Newest First"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
