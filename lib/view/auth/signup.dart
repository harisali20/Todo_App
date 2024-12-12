import 'package:flutter/material.dart';
import 'package:todo_app_task/Utility.dart';

import '../../main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

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
              padding: EdgeInsets.only(
                  left: mq.size.width * 0.2,
                  right: mq.size.width * 0.2,
                  bottom: mq.size.height * 0.05),
              child: Image.asset('lib/assets/images/Union.png'),
            ),
            SizedBox(
              height: mq.size.height * 0.4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        enabledBorder: borderDecor(textFieldColor),
                        focusedBorder: borderDecor(textFieldColor),
                        hintText: 'Full Name',
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
                        suffixIcon: suffixButton(isPasswordVisible, false),
                        enabledBorder: borderDecor(textFieldColor),
                        focusedBorder: borderDecor(textFieldColor),
                        hintStyle: TextStyle(
                          color: textFieldColor,
                        ),
                        suffixIconColor: textFieldColor,
                      ),
                    ),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: !isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: 'Confirm Password',
                        suffixIcon: suffixButton(isConfirmPasswordVisible, true),
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
            Padding(
              padding: EdgeInsets.only(
                  left: mq.size.width * 0.05,
                  right: mq.size.width * 0.05,
                  bottom: mq.size.height * 0.02),
              child: ElevatedButton(
                onPressed: () {
                  if(_emailController.text.isEmpty || _fullNameController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                      snackBar('Please fill all the fields'),
                    );
                    return;
                  }
                  if(!RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$').hasMatch(_emailController.text)){
                    ScaffoldMessenger.of(context).showSnackBar(
                      snackBar('Please enter a valid email.'),
                    );
                    return;
                  }
                  else {
                    prefs?.setString('Email', _emailController.text);
                  }
                  prefs?.setString('Full Name', _fullNameController.text);
                  if(_passwordController.text == _confirmPasswordController.text){
                    prefs?.setString('Password', _passwordController.text);
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      snackBar('Passwords do not match'),

                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    snackBar('Sign Up Successful'),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(mq.size.width, mq.size.height * 0.07),
                  foregroundColor: Colors.white,
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(mq.size.width * 0.05),
                  ),
                ),
                child: const Text('SIGN UP'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Have an account?',
                  style: TextStyle(
                    color: textFieldColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signIn');
                  },
                  child: Text(
                    'Sign In',
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

  IconButton suffixButton(bool visible, bool isConfirmPassword) {
    return IconButton(
      onPressed: () {
        if (isConfirmPassword) {
          setState(() {
            isConfirmPasswordVisible = !isConfirmPasswordVisible;
          });
        } else {
          setState(() {
            isPasswordVisible = !isPasswordVisible;
          });
        }
      },
      icon: Icon(
        visible ? Icons.visibility : Icons.visibility_off,
      ),
    );
  }
}
