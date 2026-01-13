import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:stylex/bloc/cart_bloc.dart';
import 'package:stylex/bloc/product_detals_bloc.dart';
import 'package:stylex/bloc/wishlist_bloc.dart';
import 'package:stylex/firebase_options.dart';
import 'package:stylex/models/HiveModelCart.dart';
import 'package:stylex/models/HiveModelWishlist.dart';
import 'package:stylex/repositories/cart_repository.dart';
import 'package:stylex/repositories/product_repository.dart';
import 'package:stylex/repositories/wishlist_repository.dart';
import 'package:stylex/screens/cart_screen.dart';
import 'package:stylex/screens/login/phoneipScreen.dart';
import 'package:stylex/screens/nav_bar.dart';
import 'package:stylex/screens/Home/notifications.dart';
import 'package:stylex/screens/productsScreen.dart';
import 'package:stylex/screens/purchase.dart';
import 'package:stylex/screens/Home/search_screen.dart';
import 'package:stylex/screens/splash_screen.dart';
import 'package:stylex/screens/wishlist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylex/services/api/search_product_details.dart';
import 'package:stylex/services/hive/cart_service.dart';
import 'package:stylex/services/hive/wishlist_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemHiveAdapter());
  Hive.registerAdapter(WishlistItemHiveAdapter());
  await Hive.openBox<CartItemHive>('cartBox');
  await Hive.openBox('search_history');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  CartBloc(CartRepository(localService: CartLocalService()))
                    ..add(LoadCart()),
        ),
        BlocProvider(create: (_)=>WishlistBloc(WishlistRepository(WishlistLocalService()))),
        BlocProvider(create: (_)=>ProductDetailsBloc(repository:ProductRepository(apiService: ApiService())
        )
        ),
        
        
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => NavBarScreen(),
        '/search': (context) => SearchScreen(),
        '/purchaseBag': (context) => PurchasesPage(),
        '/Notification': (context) => Notificationscreen(),
        '/Wishlist': (context) => WishlistScreen(),
        '/Order': (context) => CartPage(),
        '/Products': (context) => productsPage(search: 'sho'),
        '/login': (context) => PhoneInputPage(),
      },
    );
  }
}
