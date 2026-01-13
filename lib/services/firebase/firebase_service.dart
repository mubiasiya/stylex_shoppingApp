import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylex/screens/nav_bar.dart';
import 'package:stylex/services/api/createUserApi.dart';
import 'package:stylex/utils/prefs.dart';
import 'package:stylex/widgets/scaff_msg.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

String? _verificationId;

Future<void> sendOtp(String phone) async {
  await _auth.verifyPhoneNumber(
    phoneNumber: phone,
    timeout: const Duration(seconds: 60),

    verificationCompleted: (PhoneAuthCredential credential) async {
      // Auto verification (Android)
      await _auth.signInWithCredential(credential);
    },

    verificationFailed: (FirebaseAuthException e) {
      print("OTP Failed: ${e.message}");
    },

    codeSent: (String verificationId, int? resendToken) {
      _verificationId = verificationId;
      print("OTP Sent");
    },

    codeAutoRetrievalTimeout: (String verificationId) {
      _verificationId = verificationId;
    },
  );
}

Future<void> verifyOtp(String otp, BuildContext context) async {
  try {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    UserCredential userCredential = await _auth.signInWithCredential(
      credential,
    );

    
    final user = userCredential.user;

    await Prefs.setLoggedIn(true);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => NavBarScreen()),
      (route) => false,
    );
    message(context, 'Successfully logged in');
    loginAndSyncWithBackend(user!);
  
    
  } catch (e) {
    message(context, 'Failed to login:$e');
  }
}

Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    await Prefs.setLoggedIn(false);
    message(context, 'Logged Out');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  } catch (e) {
    message(context, 'Failed to logout:$e');
  }
}

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}

Future<void> sendTokenToBackend(String token) async {
  await http.post(
    Uri.parse("https://your-backend.com/auth/firebase-login"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );
}
