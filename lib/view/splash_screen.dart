import 'package:flutter/material.dart';
import 'package:todo_app_task/main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLogged = prefs?.getBool('isLoggedIn') ?? false;
    Future.delayed(const Duration(seconds: 3), () {
      isLogged ? Navigator.pushNamed(context, '/home') : Navigator.pushNamed(context, '/signIn');
    });
    return Scaffold(
      body: Center(
        child: Image.asset('lib/assets/images/Union.png'),
      ),
    );
  }
}