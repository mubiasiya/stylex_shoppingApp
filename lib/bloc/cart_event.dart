part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class AddToCart extends CartEvent {
  final Product product;
  final int qty;
  AddToCart(this.product, this.qty);
}

class RemoveFromCart extends CartEvent {
  final String productId;
  RemoveFromCart(this.productId);
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int qty;
  UpdateQuantity(this.productId, this.qty);
}

class ToggleSelection extends CartEvent {
  final String productId;
  ToggleSelection(this.productId);
}

class LoadCart extends CartEvent {}

class RemoveSelectedItems extends CartEvent {}
