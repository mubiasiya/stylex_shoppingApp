import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylex/models/addressModel.dart';
import 'package:stylex/screens/accountScreen.dart';
import 'package:stylex/screens/ordersucceedScreen.dart';
import 'package:stylex/utils/prefs.dart';
import 'package:stylex/widgets/elivated_button.dart';
import 'package:stylex/bloc/cart_bloc.dart';
import 'package:stylex/widgets/navigation.dart';
import 'package:stylex/widgets/scaff_msg.dart';

class CheckoutPage extends StatefulWidget {
  final int total_price;

  const CheckoutPage({super.key, required this.total_price});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int selectedAddress = 0;
  String paymentMethod = "COD";

  List<AddressModel> addresses = [];

  @override
  void initState() {
    super.initState();
    loadAdress();
  }

  void loadAdress() async {
    List<AddressModel> localAddresses = await Prefs.loadAddressesLocally();
    setState(() {
      addresses = localAddresses;
    });
  }

  @override
  Widget build(BuildContext context) {
    int price = widget.total_price;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ADDRESS
            const Text(
              "Delivery Address",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ...List.generate(addresses.length, (index) {
              final addr = addresses[index];
              return _addressCard(addr, index);
            }),

            Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountPage(),
                      ),
                    );
                    loadAdress();
                  },
                  child: Text("Add New", style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// PAYMENT
            const Text(
              "Payment Method",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _paymentTile("Cash on Delivery", "COD"),
            _paymentTile("UPI", "UPI"),
            _paymentTile("Credit / Debit Card", "CARD"),

            const SizedBox(height: 20),

            /// PRICE DETAILS
            _priceDetails(price),
          ],
        ),
      ),

      bottomNavigationBar: _bottomBar(context, price),
    );
  }

  Widget _addressCard(AddressModel addr, int index) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedAddress = index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                selectedAddress == index
                    ? Colors.deepOrange
                    : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Radio(
              value: index,
              groupValue: selectedAddress,
              onChanged: (_) {
                setState(() => selectedAddress = index);
              },
              activeColor: Colors.deepOrange,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    addr.fullAddress,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentTile(String title, String value) {
    return RadioListTile(
      value: value,
      groupValue: paymentMethod,
      activeColor: Colors.deepOrange,
      onChanged: (v) {
        setState(() => paymentMethod = v.toString());
      },
      title: Text(title),
    );
  }

  Widget _priceDetails(int price) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _priceRow("Item Total", price),
          _priceRow("Delivery Fee", 0),
          const Divider(),
          _priceRow("Total Payable", price, bold: true),
        ],
      ),
    );
  }

  Widget _priceRow(String label, int value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "₹$value",
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar(BuildContext context, int price) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state.status == CartStatus.success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => OrderSuccessPage()),
          );
        } else if (state.status == CartStatus.error) {
          message(context, 'Failed to place order,Please try again later');
        }
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "₹$price",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: button(
                context.watch<CartBloc>().state.status == CartStatus.loading
                    ? 'PLEASE WAIT...'
                    : 'PROCEED',
                () {
                  // context.read<CartBloc>().add(RemoveSelectedItems());
                  context.read<CartBloc>().add(
                    PlaceOrderEvent(
                      address:
                          addresses[selectedAddress].fullAddress.toString(),
                      totalAmount: price.toDouble(),
                    ),
                  );
                  context.watch<CartBloc>().state.status == CartStatus.success
                      ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => OrderSuccessPage()),
                      )
                      : null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
