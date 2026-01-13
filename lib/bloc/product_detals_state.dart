part of 'product_detals_bloc.dart';

enum ProductDetailsStatus { initial, loading, success, failure }

class ProductDetailsState {
  final Product? product;
  final ProductDetailsStatus status;
  final String? errorMessage;

  ProductDetailsState({
    this.product,
    this.status = ProductDetailsStatus.initial,
    this.errorMessage,
  });

  ProductDetailsState copyWith({
    Product? product,
    ProductDetailsStatus? status,
    String? errorMessage,
  }) {
    return ProductDetailsState(
      product: product ?? this.product,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// class ProductModel {
// }
