part of 'cart_bloc.dart';

enum CartStatus { initial, loading, success, alreadyInCart, error }

@immutable
class CartState {
  final List<CartItem> items;
  final bool loading;
  final String? error;
  final CartStatus status;

  const CartState({
    required this.items,
    this.status = CartStatus.initial,
    this.loading = false,
    this.error,
  });

  /// Initial state
  factory CartState.initial() {
    return const CartState(items: []);
  }

  /// CopyWith
  CartState copyWith({List<CartItem>? items, CartStatus? status}) {
    return CartState(items: items ?? this.items, status: status ?? this.status);
  }

  int get totalItemsCount => items.fold(0, (sum, item) => sum + item.qty);
}
