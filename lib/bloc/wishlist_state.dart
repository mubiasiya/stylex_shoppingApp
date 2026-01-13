part of 'wishlist_bloc.dart';

@immutable
class WishlistState {
  final List<WishlistItem> items;
  final Set<String> wishlistIds; // For O(1) lookups in Search/Home
  final bool isLoading;

  WishlistState({
    this.items = const [],
    this.wishlistIds = const {},
    this.isLoading = false,
  });

  WishlistState copyWith({
    List<WishlistItem>? items,
    Set<String>? wishlistIds,
    bool? isLoading,
  }) {
    return WishlistState(
      items: items ?? this.items,
      wishlistIds: wishlistIds ?? this.wishlistIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
