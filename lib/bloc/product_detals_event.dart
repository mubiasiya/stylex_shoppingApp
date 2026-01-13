part of 'product_detals_bloc.dart';

abstract class ProductDetailsEvent {}

class LoadProductDetails extends ProductDetailsEvent {
  final String productId;
  LoadProductDetails(this.productId);
}
