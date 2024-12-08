import 'package:flutter/material.dart';
import 'package:todo_app_task/Utility.dart';
import 'package:todo_app_task/main.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: mq.size.width * 0.2,
                  vertical: mq.size.height * 0.1),
              child: Image.asset('lib/assets/images/Union.png'),
            ),
            SizedBox(
              height: mq.size.height * 0.17,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        enabledBorder: borderDecor(textFieldColor),
                        focusedBorder: borderDecor(textFieldColor),
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: textFieldColor,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        enabledBorder: borderDecor(textFieldColor),
                        focusedBorder: borderDecor(textFieldColor),
                        hintStyle: TextStyle(
                          color: textFieldColor,
                        ),
                        suffixIconColor: textFieldColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgot');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: textFieldColor,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: mq.size.width * 0.05,
                  right: mq.size.width * 0.05,
                  bottom: mq.size.height * 0.02),
              child: ElevatedButton(
                onPressed: () {
                  if(_emailController.text.isEmpty || _passwordController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all the fields'),
                      ),
                    );
                    return;
                  }
                  if(prefs?.getString('Email') != _emailController.text || prefs?.getString('Password') != _passwordController.text){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid Email or Password'),
                      ),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Login Successful'),
                    ),
                  );
                  prefs?.setBool('isLoggedIn', true);
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(mq.size.width, mq.size.height * 0.07),
                  foregroundColor: Colors.white,
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(mq.size.width * 0.05),
                  ),
                ),
                child: const Text('Sign In'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account? ',
                  style: TextStyle(
                    color: textFieldColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: buttonColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
