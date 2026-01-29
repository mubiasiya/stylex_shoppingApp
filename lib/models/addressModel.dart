class AddressModel {
  final String? id;
  final String name, mobile, pincode, house, street, landmark, city;

  AddressModel({
    this.id,
    required this.name,
    required this.mobile,
    required this.pincode,
    required this.house,
    required this.street,
    required this.landmark,
    required this.city,
  });

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'name': name,
      'mobile': mobile,
      'pincode': pincode,
      'house': house,
      'street': street,
      'landmark': landmark,
      'city': city,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
     id: (map['_id'] ?? map['id'])?.toString(),
      name: map['name'] ?? '',
      mobile: map['mobile'] ?? '',
      pincode: map['pincode'] ?? '',
      house: map['house'] ?? '',
      street: map['street'] ?? '',
      landmark: map['landmark'] ?? '',
      city: map['city'] ?? '',
    );
  }

  String get fullAddress =>
      "$name\n$house\n$street\n$landmark\n$city - $pincode\n$mobile";
}
