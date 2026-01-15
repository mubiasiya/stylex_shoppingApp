

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> loginAndSyncWithBackend(User firebaseUser) async {
  
  String? token = await firebaseUser.getIdToken();
  
  
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token!);
  await prefs.setString('firebase_uid', firebaseUser.uid);

  
  final url = Uri.parse('https://shopapp-server-dnq1.onrender.com/api/auth/login-sync');
  
  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "firebaseUid": firebaseUser.uid,
        "phone": firebaseUser.phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("MongoDB User ID: ${data['userId']}");
    }
  } catch (e) {
    print("Backend Sync Error: $e");
  }
}