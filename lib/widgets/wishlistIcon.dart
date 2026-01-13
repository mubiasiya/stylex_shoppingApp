 
 import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stylex/screens/wishlist.dart';
import 'package:stylex/widgets/navigation.dart';

Widget wishlist(BuildContext context){
  return  IconButton(
            onPressed: () {
               navigation(context, WishlistScreen());
            },
            icon: Icon(Icons.favorite_border, color: Colors.black),
            tooltip: "Wishlist",
          );
}
 