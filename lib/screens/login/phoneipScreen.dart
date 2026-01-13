import 'package:flutter/material.dart';
import 'package:stylex/screens/login/otp_verification.dart';
import 'package:stylex/services/firebase/firebase_service.dart';
import 'package:stylex/widgets/elivated_button.dart';
import 'package:stylex/widgets/navigation.dart';

class PhoneInputPage extends StatefulWidget {
  const PhoneInputPage({super.key});

  @override
  State<PhoneInputPage> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<PhoneInputPage> {
  final TextEditingController phoneCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              Text(
                "Enter your mobile number",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                "We will send you an OTP to verify",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),

              const SizedBox(height: 50,),

              /// PHONE INPUT
              Center(
                child: SizedBox(
                  
                  width: 250,
                  child: TextField(
                    controller: phoneCtrl,
                    onChanged: (v){
                      setState(() {
                        
                      });
                    },
                    keyboardType: TextInputType.phone,
                        cursorColor: Colors.black,
                    autofocus: true,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    decoration: InputDecoration(
                      prefixText: "   +91 ",
                      prefixStyle: TextStyle(color: Colors.black, fontSize: 20),
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
                  ),
                ),
              ),

             SizedBox(height: 100,),

              phoneCtrl.text.length>=10?
              Center(
                child: button('SEND OTP', (){
                  print('hellooi');
                  sendOtp('+91${phoneCtrl.text.trim()}');
                  navigation(context, OtpVerificationPage(phone: phoneCtrl.text));
                }),
              ):Text('')

            
            ],
          ),
        ),
      ),
    );
  }
}
