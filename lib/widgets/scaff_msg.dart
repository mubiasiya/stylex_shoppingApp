 import 'package:flutter/material.dart';
ScaffoldFeatureController message(BuildContext context,String msg){

return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

}

