import 'package:flutter/material.dart';

Widget title(String title){
  return  Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        );
}