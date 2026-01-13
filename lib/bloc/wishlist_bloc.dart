import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stylex/models/wishlistItemModel.dart';
import 'package:stylex/repositories/wishlist_repository.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository repository;

  WishlistBloc(this.repository) : super(WishlistState()) {
    // --- LOAD WISHLIST ---
    on<LoadWishlist>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final items = await repository.getWishlist();

      // Extract IDs into a Set for fast lookup
      final ids = items.map((e) => e.productId).toSet();

      emit(state.copyWith(items: items, wishlistIds: ids, isLoading: false));
    });

    // --- TOGGLE WISHLIST ---
    on<ToggleWishlist>((event, emit) async {
      final updatedItems = List<WishlistItem>.from(state.items);
      final updatedIds = Set<String>.from(state.wishlistIds);
      final productId = event.item.productId;

      if (updatedIds.contains(productId)) {
        // Remove logic
        updatedIds.remove(productId);
        updatedItems.removeWhere((i) => i.productId == productId);
        await repository.removeFromWishlist(productId);
      } else {
        // Add logic
        updatedIds.add(productId);
        updatedItems.add(event.item);
        await repository.addToWishlist(event.item);
      }

      emit(state.copyWith(items: updatedItems, wishlistIds: updatedIds));
    });

    // Auto-load when bloc is created
    add(LoadWishlist());
  }
}
