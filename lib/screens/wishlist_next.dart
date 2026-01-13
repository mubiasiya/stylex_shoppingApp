import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylex/bloc/product_detals_bloc.dart';
import 'package:stylex/screens/productDetails_wishlist.dart';


class wishlistNext extends StatefulWidget {
  final String productId;
  const wishlistNext({super.key, required this.productId});

  @override
  State<wishlistNext> createState() => _wishlistNextState();
}

class _wishlistNextState extends State<wishlistNext> {
  @override
  void initState() {
    super.initState();
    // Trigger the API call when the page opens
    context.read<ProductDetailsBloc>().add(LoadProductDetails(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          if (state.status == ProductDetailsStatus.loading) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent,));
          }

          if (state.status == ProductDetailsStatus.failure) {
            return Center(child: Text("Error: ${state.errorMessage}"));
          }

          if (state.status == ProductDetailsStatus.success &&
              state.product != null) {
            
            return MyFullProductUI(product: state.product!);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
