class AddressModel {
  final String name, mobile, pincode, house, street, landmark, city;

  AddressModel(this.name, this.mobile, this.pincode, this.house, this.street,
      this.landmark, this.city);

  String get fullAddress =>
      "$house \n $street\n $landmark\n $city - $pincode\n $mobile";
}
