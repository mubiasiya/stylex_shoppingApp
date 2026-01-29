import 'package:flutter/material.dart';
import 'package:stylex/models/addressModel.dart';
import 'package:stylex/services/api/addressSync.dart';
import 'package:stylex/services/firebase/firebase_service.dart';
import 'package:stylex/utils/prefs.dart';
import 'package:stylex/widgets/backbutton.dart';
import 'package:stylex/widgets/elivated_button.dart';
import 'package:stylex/widgets/title.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<AddressModel> addresses = [];
  // Controllers
  final nameCtrl = TextEditingController(text: "Asiyath Mubeena");
  final phoneCtrl = TextEditingController(text: "9876543210");
  final emailCtrl = TextEditingController(text: "mubeena@gmail.com");

  bool isChanged = false;

  void loadAdress() async {
    List<AddressModel> localAddresses = await Prefs.loadAddressesLocally();
    print("id${localAddresses[0].id}");
    setState(() {
      addresses = localAddresses;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAdress();

    for (var c in [nameCtrl, phoneCtrl, emailCtrl]) {
      c.addListener(() {
        setState(() => isChanged = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title('Account'),
        leading: backArrow(context),
        actions: [
          if (isChanged)
            TextButton(
              onPressed: () {
                setState(() => isChanged = false);
              },
              child: const Text(
                "SAVE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _profileCard(),
            const SizedBox(height: 30),
            _addressSection(),
          ],
        ),
      ),
      floatingActionButton: button('LOGOUT', () {
        signOut(context);
      }),
    );
  }

  // PROFILE CARD
  Widget _profileCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepOrange.withOpacity(0.5), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _field("Name", Icons.person, nameCtrl),
            _field("Mobile", Icons.phone, phoneCtrl, type: TextInputType.phone),
            _field("Email", Icons.email, emailCtrl),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    IconData icon,
    TextEditingController ctrl, {
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ADDRESS SECTION
  Widget _addressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Saved Addresses",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => openAddressSheet(),
              child: Text("Add New", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        const SizedBox(height: 12),
       
        ...addresses.map(_addressCard),
      ],
    );
  }

  Widget _addressCard(AddressModel address) {
    return GestureDetector(
      onTap: () => openAddressSheet(address: address, flag: 1),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.deepOrange.withOpacity(0.5),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 12),

        child: ListTile(
          title: Text(address.name),
          subtitle: Text(address.fullAddress),
        ),
      ),
    );
  }

  // ADDRESS BOTTOM SHEET
  void openAddressSheet({AddressModel? address, int flag = 0}) {
    final name = TextEditingController(text: address?.name);
    final phone = TextEditingController(text: address?.mobile);
    final pin = TextEditingController(text: address?.pincode);
    final house = TextEditingController(text: address?.house);
    final street = TextEditingController(text: address?.street);
    final landmark = TextEditingController(text: address?.landmark);
    final city = TextEditingController(text: address?.city);

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              top: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _sheetField("Name", name),
                  _sheetField("Mobile", phone, TextInputType.phone),
                  _sheetField("Pincode", pin, TextInputType.number),
                  _sheetField("House / Flat No", house),
                  _sheetField("Street", street),
                  _sheetField("Landmark", landmark),
                  _sheetField("City", city),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: flag == 0 ? 200 : 400,

                    child:
                        flag == 0
                            ? button('SAVE', () async {
                              final newAddress = AddressModel(
                                name: name.text,
                                mobile: phone.text,
                                pincode: pin.text,
                                house: house.text,
                                street: street.text,
                                landmark: landmark.text,
                                city: city.text,
                              );

                              List<AddressModel> freshList =
                                  await syncAddressToMongo(newAddress);

                              setState(() {
                                addresses =
                                    freshList; 
                              });

                              // setState(() {
                              //   addresses.add(newAddress);
                              // });

                              Navigator.pop(context);
                            })
                            : Row(
                              children: [
                                button('REMOVE', () {
                                  Deleteaddress(address!);

                                  setState(() {
                                    addresses.remove(address);
                                  });
                                  Navigator.pop(context);
                                }),

                                Spacer(),
                                button('EDIT', () {
                                  final newAddress = AddressModel(
                                    id: address?.id,
                                    name: name.text,
                                    mobile: phone.text,
                                    pincode: pin.text,
                                    house: house.text,
                                    street: street.text,
                                    landmark: landmark.text,
                                    city: city.text,
                                  );
                                  editaddress(newAddress);
                                  setState(() {
                                    addresses[addresses.indexOf(address!)] =
                                        newAddress;
                                  });

                                  Navigator.pop(context);
                                }),
                              ],
                            ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _sheetField(
    String label,
    TextEditingController ctrl, [
    TextInputType type = TextInputType.text,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
