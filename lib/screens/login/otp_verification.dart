import 'package:flutter/material.dart';
import 'package:stylex/services/firebase/firebase_service.dart';
import 'package:stylex/widgets/elivated_button.dart';



class OtpVerificationPage extends StatefulWidget {
  final String phone;

  const OtpVerificationPage({super.key, required this.phone});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> otpCtrls = List.generate(
    6,
    (_) => TextEditingController(),
  );
  late int j = 0;
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),

                const SizedBox(height: 20),

                const SizedBox(height: 8),

                Text(
                  "Enter OTP we have been sent to \n +91 ${widget.phone}",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 60),

                /// OTP BOXES
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(6, (i) {
                      return SizedBox(
                        width: 50,
                        child: TextField(
                          controller: otpCtrls[i],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          maxLength: 1,
                          autofocus: true,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          decoration: InputDecoration(
                            counterText: "",

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.deepOrange.withOpacity(0.6),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.deepOrange.withOpacity(0.6),
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (val) {
                            if (val.isNotEmpty && i < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                            if (i == 5) {
                              setState(() {
                                j = 1;
                              });
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 100),

                j == 1
                    ? Center(
                      child: button('VERIFY OTP', () async{
                        String otpValue = otpCtrls.map((controller) => controller.text).join();
                        verifyOtp(otpValue,context);
                       
                        
                      }),
                    )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
