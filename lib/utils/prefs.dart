import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylex/models/addressModel.dart';

class Prefs {
  static const String _isLoggedIn = 'isLoggedIn';

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedIn, value);
  }

  /// GET LOGIN STATUS
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedIn) ?? false;
  }

  static Future<void> saveAddressLocally(List<AddressModel> addressList) async {
    final prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> mapList =
        addressList.map((a) => a.toMap()).toList();

    String encodedData = jsonEncode(mapList);

    await prefs.setString('user_addresses', encodedData);
  }

  static Future<List<AddressModel>> loadAddressesLocally() async {
    final prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('user_addresses');

    if (encodedData != null) {
      List<dynamic> decodedData = jsonDecode(encodedData);

      return decodedData.map((item) => AddressModel.fromMap(item)).toList();
    }
    return [];
  }
}
