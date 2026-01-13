import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stylex/models/cartItemModel.dart';
import 'package:stylex/models/productModel.dart';
import 'package:stylex/repositories/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc(this.repository) : super(CartState(items: [])) {
    
    // --- LOAD CART ---
    on<LoadCart>((event, emit) async {
      final items = await repository.loadCart();
      emit(CartState(items: items));
    });

    // --- ADD TO CART ---
    on<AddToCart>((event, emit) async {
      final items = List<CartItem>.from(state.items);
      final index = items.indexWhere((i) => i.productId == event.product.id);

      CartItem itemToSync;

      if (index == -1) {
        itemToSync = CartItem(
          productId: event.product.id,
          title: event.product.title,
          image: event.product.image,
          price: event.product.offerPrice,
          qty: event.qty,
        );

        items.add(itemToSync);
        emit(state.copyWith(items: items, status: CartStatus.success));
        emit(state.copyWith(status: CartStatus.initial));

      } else {
       
        items[index] = items[index].copyWith(qty: items[index].qty + event.qty);
        itemToSync = items[index];
         emit(state.copyWith(status: CartStatus.alreadyInCart));
        emit(state.copyWith(status: CartStatus.initial));
      }

      

      // 2. Repository handles Hive save AND Background Backend Sync
      await repository.addItem(itemToSync);
    });

    // --- REMOVE FROM CART ---
    on<RemoveFromCart>((event, emit) async {
      final remainingItems =
          state.items.where((i) => i.productId != event.productId).toList();

      // 1. Update UI
      emit(CartState(items: remainingItems));

      // 2. Tell Repository to remove from Hive and Sync deletion to Cloud
      await repository.removeItem(event.productId);
    });

    // --- UPDATE QUANTITY ---
    on<UpdateQuantity>((event, emit) async {
      final items =
          state.items.map((item) {
            return item.productId == event.productId
                ? item.copyWith(qty: event.qty, synced: false)
                : item;
          }).toList();

      // 1. Update UI
      emit(CartState(items: items));

      // 2. Repository updates Hive and Syncs new quantity
      await repository.updateQuantity(event.productId, event.qty);
    });

    // --- TOGGLE SELECTION (Local Only) ---
    on<ToggleSelection>((event, emit) async {
      final items =
          state.items.map((item) {
            return item.productId == event.productId
                ? item.copyWith(selected: !item.selected)
                : item;
          }).toList();

      emit(CartState(items: items));

      // Usually, 'selected' status isn't synced to DB, so we just save locally
      await repository.localService.toggleSelection(event.productId);
    });

    // --- REMOVE SELECTED (Order Placed) ---
    on<RemoveSelectedItems>((event, emit) async {
      final remainingItems =
          state.items.where((item) => !item.selected).toList();

      // 1. Update UI
      emit(CartState(items: remainingItems));

      // 2. Repository wipes selected from Hive and overwrites Cloud Cart
      await repository.clearSelectedItems(remainingItems);
    });

   
  }
}
