import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:stylex/screens/accountScreen.dart';
import 'package:stylex/screens/purchase.dart';
import 'package:stylex/screens/wishlist.dart';
import 'package:stylex/widgets/navigation.dart';
import 'package:stylex/widgets/title.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: title('My space'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 4,
                children: [
                  _profileButton(
                    icon: Icons.person_outline,
                    title: "Account",

                    onTap: () {
                      navigation(context, AccountPage());
                    },
                  ).animate().slideX(begin: -1, duration: 500.ms).fadeIn(),

                  _profileButton(
                    icon: Icons.shopping_bag_outlined,
                    title: "Purchases",

                    onTap: () {
                      navigation(context, PurchasesPage());
                    },
                  ).animate().slideX(begin: 1, duration: 500.ms).fadeIn(),

                  _profileButton(
                    icon: Icons.favorite_border,
                    title: "Wishlist",

                    onTap: () {
                      navigation(context, WishlistScreen());
                    },
                  ).animate().slideY(begin: 1, duration: 500.ms).fadeIn(),

                  _profileButton(
                    icon: Icons.settings_outlined,
                    title: "Settings",

                    onTap: () {},
                  ).animate().slideY(begin: -1, duration: 500.ms).fadeIn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 15),
            
            Container(
              
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.deepOrange.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black, size: 28),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}


