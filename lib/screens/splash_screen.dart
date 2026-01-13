import 'package:flutter/material.dart';
import 'package:stylex/utils/prefs.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _moveController;
  late AnimationController _fadeController;

  late Animation<Offset> _leftMove;
  late Animation<Offset> _rightMove;
  late Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();

    _moveController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _leftMove = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeOut,
    ));

    _rightMove = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeOut,
    ));

    _fadeOut = Tween<double>(begin: 1, end: 0).animate(_fadeController);

    _moveController.forward();

    Future.delayed(Duration(seconds: 4), () {
      _fadeController.forward().then((_) {
        // Navigator.pushReplacementNamed(context, "/home");
        // navigation(context, PhoneInputPage());
        _checkLogin();
      });
    });
  }

  @override
  void dispose() {
    _moveController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeOut,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _leftMove,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.5,
                    child: Image.asset(
                      'assets/images/logo1.png',
                      width: 250,
                      height: 300,
                    ),
                  ),
                ),
              ),
              SlideTransition(
                position: _rightMove,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.centerRight,
                    widthFactor: 0.5,
                    child: Image.asset(
                      'assets/images/logo1.png',
                      width: 250,
                      height: 300,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkLogin() async {
  bool loggedIn = await Prefs.isLoggedIn();

  Future.delayed(const Duration(seconds: 2), () {
    if (loggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  });
}
}


