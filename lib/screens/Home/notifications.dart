import 'package:flutter/material.dart';
import 'package:stylex/widgets/backbutton.dart';
import 'package:stylex/widgets/title.dart';

class Notificationscreen
 extends StatelessWidget {
  const Notificationscreen
  ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: backArrow(context),
        title: title('Notifications'),
      ),
      body: Column(
        children:[
          SizedBox(height: 100,),
           Center(
             child: Text('You dont have any notifications',
                     style: TextStyle(
                       color: Colors.black,
                       fontSize: 15,
                       fontWeight: FontWeight.w500
             
                     ),),
           ),
        ]
      ),

    );
  }
}