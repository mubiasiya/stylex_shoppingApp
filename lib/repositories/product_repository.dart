import 'dart:developer';
import 'package:stylex/models/productModel.dart';
import 'package:stylex/services/api/search_product_details.dart';


class ProductRepository {
  final ApiService apiService;

  // Simple Cache: Stores Product ID as Key and Product Object as Value
  final Map<String, Product> _productCache = {};

  ProductRepository({required this.apiService});

  Future<Product> getProductById(String id) async {
    try {
      //  Check if we already have this product in memory
      if (_productCache.containsKey(id)) {
        print("Returning cached data for product: $id");
        return _productCache[id]!;
      }

      //  If not in cache, fetch from API
      print("Fetching fresh data from API for product: $id");
      final response = await apiService.get('/product/$id');

      //  Convert JSON to Model
      final product = Product.fromJson(response.data);

      //  Save to cache for future use
      _productCache[id] = product;

      return product;
    } catch (e) {
      log("Error in ProductRepository: $e");
      rethrow; // Pass the error back to the BLoC
    }
  }

 
  void clearCache() => _productCache.clear();
}
