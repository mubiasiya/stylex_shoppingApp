part of 'wishlist_bloc.dart';

@immutable
sealed class WishlistEvent {}

class LoadWishlist extends WishlistEvent {}

class ToggleWishlist extends WishlistEvent {
  final WishlistItem item;
  ToggleWishlist(this.item);
}
