import 'package:flutter/material.dart';
import 'package:todo_app_task/Utility.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
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
              height: mq.size.height * 0.25,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      controller: _passwordController,
                      obscureText: isPasswordVisible,
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
                      obscureText: isConfirmPasswordVisible,
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    snackBar('Password Changed Successfully')
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
                child: const Text('Change Password'),
              ),
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
        visible ? Icons.visibility_off : Icons.visibility,
      ),
    );
  }
}
