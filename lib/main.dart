import 'package:flutter/material.dart';
import 'package:todo_app_task/view/auth/forgot_password_screen.dart';
import 'package:todo_app_task/view/auth/loginscreen.dart';
import 'package:todo_app_task/view/auth/signup.dart';
import 'package:todo_app_task/view/home/home_screen.dart';
import 'package:todo_app_task/view/tasks/task_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;
void main() async{
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {

    bool isLogged = prefs?.getBool('isLoggedIn') ?? false;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLogged ? '/' : '/home',
      routes: {
        '/': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgot' : (context) => const ForgotPasswordScreen(),
        '/home' : (context) => const HomeScreen(),
      },
    );
  }
}