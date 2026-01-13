import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void navigation(BuildContext context,Widget page){
  Navigator.push(context, CupertinoPageRoute(builder: (_) => page));
}