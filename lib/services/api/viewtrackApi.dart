import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "https://shopapp-server-dnq1.onrender.com";
Future<void> trackUserInterest(String category) async {
   final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString('firebase_uid');

  if (uid != null) {
   
   try{
    final response=
  await http.post(
    Uri.parse('$baseUrl/api/trackview/'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"firebaseUid": uid, "category": category}),
  );
  print('something');
  print(response.body);

   }
   catch(e){
    print('error');
    print(e.toString());
   }
  
  }
}
