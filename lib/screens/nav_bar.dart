import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stylex/screens/purchase.dart';
import 'package:stylex/widgets/navigation.dart';
import 'Home/home_screen.dart';
import 'categories_screen.dart';

import 'profile_screen.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens =  [
    HomeScreen(),
    CategorySideScreen(),
    PurchasesPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _screens[_currentIndex],
      ),

      bottomNavigationBar: Container(
        height: 75,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (i) {
            final selected = _currentIndex == i;

            final icons = [
              'assets/icons/home1.svg',
              'assets/icons/categories.svg',
              'assets/icons/purchases.svg',
              'assets/icons/profile.svg',
            ];

            final labels = ['Home', 'Categories', 'Purchases', 'Me'];

            return GestureDetector(
              onTap: () { 
                if(i==2){
                 navigation(context, PurchasesPage());
                }
               else if(i==3){
                navigation(context, ProfileScreen());
               }
                else{ setState(() => _currentIndex = i);}
                },
               
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                 
                  border:
                      selected
                          ? const Border(
                           
                            bottom: BorderSide(
                              color:Colors.deepOrange,
                              width: 3,
                              style: BorderStyle.solid,
                            ),
                          )
                          : null,
                ),

                child: Column(
                  children: [
                    SvgPicture.asset(
                      icons[i],

                      width: selected ? 32 : 28,
                      height: selected ? 32 : 28,
                    ),

                    Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: selected ? FontWeight.bold : null,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}



