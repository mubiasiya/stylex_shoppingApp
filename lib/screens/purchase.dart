import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stylex/widgets/backbutton.dart';
import 'package:stylex/widgets/title.dart';

class PurchasesPage extends StatefulWidget {
  const PurchasesPage({super.key});

  @override
  State<PurchasesPage> createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
  late TextEditingController search = TextEditingController();
  List<dynamic> allOrders = []; // Flat list of individual products
  List<dynamic> filteredOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrdersFromDb();
  }

  Future<void> loadOrdersFromDb() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('firebase_uid');

    try {
      final response = await http.get(
        Uri.parse(
          'https://shopapp-server-dnq1.onrender.com/api/order/my-orders/$uid',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List ordersFromApi = data['orders'] ?? [];

        List<dynamic> tempList = [];

        for (var order in ordersFromApi) {
          List items = order['items'] ?? [];
          for (var item in items) {
            tempList.add({
              "title": item['title'] ?? "Product",
              "image": item['image'] ?? "",
              "price": item['price'] ?? 0,
              "status": order['orderStatus'] ?? "processing",
              "total": order['totalAmount'] ?? 0,
            });
          }
        }

        setState(() {
          allOrders = tempList;
          filteredOrders = tempList;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error: $e");
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredOrders =
          allOrders.where((item) {
            // FIXED: Accessing title directly because the list is now flat
            final title = item['title'].toString().toLowerCase();
            return title.contains(query.toLowerCase());
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: backArrow(context),
        title: title('My purchases'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color:Colors.deepOrange.shade400,
        onRefresh:()async{
        await  loadOrdersFromDb();
          },
        child: Column(
          children: [
            _searchBar(),
            Expanded(
              child:
                  isLoading
                      ? _buildShimmerLoading()
                      : filteredOrders.isEmpty
                      ? _buildEmptyState()
                      : _buildOrderList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Spacer(),
          Container(
            height: 40,
            width: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: TextField(
              controller: search,
              onChanged: filterSearchResults,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search order',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    search.text.isNotEmpty
                        ? IconButton(
                          onPressed: () {
                            search.clear();
                            filterSearchResults('');
                          },
                          icon: const Icon(Icons.cancel, color: Colors.black),
                        )
                        : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final product = filteredOrders[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(
              right: BorderSide(color: Colors.deepOrange, width: 3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                child: CachedNetworkImage(
                  // FIXED: imageUrl is now product["image"] directly
                  imageUrl: product["image"] ?? "",
                  height: 95,
                  width: 95,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(color: Colors.grey[200]),
                  errorWidget:
                      (context, url, error) => const Icon(Icons.broken_image),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // FIXED: Accessing title directly
                      product["title"] ?? "Order Item",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Status: ${product['status']}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Price: ₹${product['price']}",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Keep your _buildShimmerLoading and _buildEmptyState as they were
  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      itemBuilder:
          (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 95,
              margin: const EdgeInsets.only(bottom: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(), // Forces the list to be pullable
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
        const Center(
          child: Text(
            "No orders found.\nPull down to refresh",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
