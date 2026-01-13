import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylex/bloc/cart_bloc.dart';
import 'package:stylex/bloc/wishlist_bloc.dart';
import 'package:stylex/models/productModel.dart';
import 'package:stylex/models/wishlistItemModel.dart';
import 'package:stylex/screens/wishlist_next.dart';
import 'package:stylex/widgets/cartIcon.dart';
import 'package:stylex/widgets/scaff_msg.dart';
import 'package:stylex/widgets/title.dart';
import 'package:stylex/widgets/navigation.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: title('Wishlist'),
        actions: [cartIcon(context), SizedBox(width: 10)],
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 500,),
                Icon(Icons.auto_awesome,color: Colors.black,),
              Text(
                'Wishlist is empty',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              ]
            );
          }
          return wishlistGrid(state.items);
        },
      ),
    );
  }
}

Widget wishlistGrid(List<WishlistItem> items) {
  return GridView.builder(
    padding: EdgeInsets.all(12),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.54,
    ),
    itemCount: items.length,
    itemBuilder: (context, index) {
      return wishlistCard(items[index], context);
    },
  );
}

Widget wishlistCard(WishlistItem item, BuildContext context) {
  int original = item.originalPrice;
  int offer = item.offerPrice;
  double percent = ((original - offer) / original) * 100;

  return GestureDetector(
    onTap: (){
      navigation(context,wishlistNext(productId: item.productId));
      
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    // borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.network(item.image, fit: BoxFit.contain),
                  ),
                ),
              ),
    
              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  onTap: (
               
    
                  ) {
                    context.read<WishlistBloc>().add(
                      ToggleWishlist(
                        WishlistItem(
                          productId: item.productId,
                          title: item.title,
                          image: item.image,
                          originalPrice: item.originalPrice,
                          offerPrice: item.offerPrice,
                          addedAt: DateTime(2025),
                        ),
                      ),
                    );
                    print("removed");
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4),
                      ],
                    ),
                    child: Icon(Icons.close, size: 18),
                  ),
                ),
              ),
            ],
          ),
    
          // CONTENT SECTION
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAME
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
    
                  SizedBox(height: 4),
    
                  // PRICE ROW
                  Row(
                    children: [
                      Text(
                        "₹${original.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        "₹${offer.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
    
                  SizedBox(height: 2),
    
                  // OFFER %
                  Text(
                    "(${percent.toStringAsFixed(0)}% OFF)",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
    
                  Spacer(),
    
                  // ADD TO BAG BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 39,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CartBloc>().add(
                          AddToCart(
                            Product(
                              id: item.productId,
                              title: item.title,
                              price: item.originalPrice,
                              offerPrice: item.offerPrice,
                              image: item.image,
                              description: '',
                              category: '',
                              tags: [''],
                              specifications: {},
                            ),
                            1,
                          ),
                        );
                        context.read<WishlistBloc>().add(
                          ToggleWishlist(
                            WishlistItem(
                              productId: item.productId,
                              title: item.title,
                              image: item.image,
                              originalPrice: item.originalPrice,
                              offerPrice: item.offerPrice,
                              addedAt: DateTime(2025),
                            ),
                          ),
                        );
                       message(context, 'Successfully added to bag');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "ADD TO BAG",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
