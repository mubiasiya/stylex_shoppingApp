import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylex/bloc/product_detals_bloc.dart';
import 'package:stylex/models/wishlistItemModel.dart';
import 'package:stylex/screens/myproduct_skelton.dart';
import 'package:stylex/screens/product_details.dart';

class ProductDetialsNext extends StatefulWidget {
  final String productId;
  final WishlistItem? initialData;
  const ProductDetialsNext({
    super.key,
    required this.productId,
    this.initialData,
  });

  @override
  State<ProductDetialsNext> createState() => _ProductDetialsNextState();
}

class _ProductDetialsNextState extends State<ProductDetialsNext> {
  @override
  void initState() {
    super.initState();
   
    context.read<ProductDetailsBloc>().add(
      LoadProductDetails(widget.productId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          if (state.status == ProductDetailsStatus.initial ||
              state.status == ProductDetailsStatus.loading) {
            return MyProductSkeleton(initialData: widget.initialData);
          }

          if (state.status == ProductDetailsStatus.success) {
            return state.product != null
                ? ProductDetailsPage(
                  product: state.product!.toMap(),
                )
                : const Center(child: Text("Product not found"));
          }

          if (state.status == ProductDetailsStatus.failure) {
            return Center(child: Text(state.errorMessage ?? 'Failure'));
          }

          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}