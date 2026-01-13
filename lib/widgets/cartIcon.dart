//cart with showing number of items
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylex/bloc/cart_bloc.dart';
import 'package:stylex/screens/cart_screen.dart';

import 'package:stylex/widgets/navigation.dart';

Widget cartIcon(BuildContext context,) {
  int count = context.select((CartBloc bloc) => bloc.state.totalItemsCount);
  return IconButton(
    onPressed: () {
   navigation(context, CartPage());
    },
    icon: Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.shopping_bag_outlined, size: 28, color: Colors.black),

        // Badge
        if (count > 0)
          Positioned(
            right: -6,
            top: -5,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                shape: BoxShape.circle,
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ),
    tooltip: "My Bag",
  );
}
