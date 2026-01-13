import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylex/bloc/cart_bloc.dart';
import 'package:stylex/models/cartItemModel.dart';
import 'package:stylex/models/wishlistItemModel.dart';
import 'package:stylex/screens/checkoutScreen.dart';
import 'package:stylex/screens/product_detials_next.dart';
import 'package:stylex/widgets/elivated_button.dart';
import 'package:stylex/widgets/navigation.dart';
import 'package:stylex/widgets/title.dart';
import 'package:stylex/widgets/wishlistIcon.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title('My Bag'),
        actions: [wishlist(context), SizedBox(width: 10)],
      ),

      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined),
                  Text(
                    "Cart is empty",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    return orderCard(index, state.items);
                  },
                ),
              ),

              placeOrderBar(state.items),
            ],
          );
        },
      ),
    );
  }

  Widget orderCard(int index, List<CartItem> cartItems) {
    final item = cartItems[index];

    return GestureDetector(
      onTap: () {
        navigation(context, ProductDetialsNext(productId: item.productId,initialData:WishlistItem(productId: item.productId,
         title: item.title,
          image: item.image, 
          originalPrice:item.price ,
           offerPrice: item.price,
            addedAt: DateTime.now()) ,));
        //  navigation(context, ProductDetailsPage(product: Product(id: item.productId,
        //   title: item.title,
        //    price: item.price,
        //     offerPrice: item.price,
        //      image: item.image,
        //       description: ''
        //       , category: '',
        //        tags: [''],
        //        specifications: {}).toMap()));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [
            // Checkbox
            Checkbox(
              activeColor: const Color.fromRGBO(
                255,
                87,
                34,
                1,
              ).withOpacity(0.7),
              value: item.selected,

              onChanged: (val) {
                context.read<CartBloc>().add(ToggleSelection(item.productId));
              },
            ),

            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              // child: Hero(
              //   tag: item.productId,
                child: Image.network(
                  item.image,
                  height: 70,
                  width: 70,
                  fit: BoxFit.contain,
                ),
              ),
            // ),

            const SizedBox(width: 12),

            // Title + Price + Qty
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "₹${item.price}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Quantity
                  Row(
                    children: [
                      InkWell(
                        onTap: () => showQtySelector(context, index, cartItems),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.shade100.withOpacity(0.4),
                              ),
                            ],

                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Qty: ${item.qty}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.keyboard_arrow_down, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Remove
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black, size: 20),
              onPressed: () {
                setState(() {
                  context.read<CartBloc>().add(RemoveFromCart(item.productId));
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void showQtySelector(
    BuildContext context,
    int index,
    List<CartItem> cartItem,
  ) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Quantity",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(10, (i) {
                  final qty = i + 1;
                  final isSelected = cartItem[index].qty == qty;

                  return GestureDetector(
                    onTap: () {
                      context.read<CartBloc>().add(
                        UpdateQuantity(cartItem[index].productId, qty),
                      );
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 42,
                      width: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Colors.deepOrange.withOpacity(0.7)
                                : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        qty.toString(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget placeOrderBar(List<CartItem> cartItems) {
    List<CartItem> selectedItems =
        cartItems.where((e) {
          return e.selected == true;
        }).toList();
    int selectedCount = selectedItems.length;
    int totalPrice = selectedItems.fold(
      0,
      (sum, item) => sum + (item.price * item.qty),
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
        ],
      ),

      child: Row(
        children: [
          // Total info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$selectedCount item(s) selected",
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 4),
                selectedCount == 0
                    ? Text('')
                    : Text(
                      "Total: ₹$totalPrice",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ],
            ),
          ),

          // Place Order Button
          selectedCount == 0
              ? Text('')
              : button('PLACE ORDER', () {
                navigation(context, CheckoutPage(total_price: totalPrice));
              }),
        ],
      ),
    );
  }
}
