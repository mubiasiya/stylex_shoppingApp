import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylex/models/addressModel.dart';
import 'package:stylex/utils/prefs.dart';

Future <List<AddressModel>> syncAddressToMongo(AddressModel newAddress) async {
  final prefss = await SharedPreferences.getInstance();
  final uid = prefss.getString('firebase_uid');

  final response = await http.post(
    Uri.parse(
      'https://shopapp-server-dnq1.onrender.com/api/address/add-address',
    ),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "uid": uid,
      "addressData": newAddress.toMap(), // Uses the model's toMap() function
    }),
  );
  print('|||');
  print(response.body);
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    List<dynamic> addressList = responseData['addresses'];

    List<AddressModel> updatedAddresses =
        addressList.map((item) => AddressModel.fromMap(item)).toList();

    await Prefs.saveAddressLocally(updatedAddresses);
    return updatedAddresses; // Return the list with the fresh IDs!
  }
  return [];
}


Future<void> editaddress(AddressModel newAddress) async {
  final prefss = await SharedPreferences.getInstance();
  final uid = prefss.getString('firebase_uid');
  print("DEBUG: addressId value: '${newAddress.id}'");
  print("DEBUG: addressId length: ${newAddress.id?.length}");

  final response = await http.put(
    Uri.parse(
      'https://shopapp-server-dnq1.onrender.com/api/address/edit-address',
    ),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "uid": uid,
      "addressId": newAddress.id, 
      "updatedAddress":newAddress.toMap()
    }),
  );
  print(response.body);
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    List<dynamic> addressList = responseData['addresses'];

    List<AddressModel> updatedAddresses =
        addressList.map((item) {
          return AddressModel.fromMap(item);
        }).toList();

    await Prefs.saveAddressLocally(updatedAddresses);

  }
}



Future<void> Deleteaddress(AddressModel newAddress) async {
  final prefss = await SharedPreferences.getInstance();
  final uid = prefss.getString('firebase_uid');

  final response = await http.post(
    Uri.parse(
      'https://shopapp-server-dnq1.onrender.com/api/address/remove-address',
    ),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "uid": uid,
      "addressId": newAddress.id,
      
    }),
  );
  print(response.body);
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);

    List<dynamic> addressList = responseData['addresses'];

    List<AddressModel> updatedAddresses =
        addressList.map((item) => AddressModel.fromMap(item)).toList();

    await Prefs.saveAddressLocally(updatedAddresses);
  }
}
