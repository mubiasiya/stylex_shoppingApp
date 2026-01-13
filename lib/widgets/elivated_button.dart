import 'package:flutter/material.dart';

Widget button(String text,VoidCallback onclick) {
  return ElevatedButton(
    onPressed:onclick,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      backgroundColor: Colors.deepOrange.withOpacity(0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: Text(
      text,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
  );
}
