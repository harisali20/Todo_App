import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool _isLoading = false;
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      // Validate inputs
                      if (_emailController.text.isEmpty ||
                          _fullNameController.text.isEmpty ||
                          _passwordController.text.isEmpty ||
                          _confirmPasswordController.text.isEmpty) {
                        snackBar('Please fill all the fields');
                        setState(() {
                          _isLoading = false;
                        });
                        return;
                      }

                      // Validate email format
                      if (!RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$')
                          .hasMatch(_emailController.text)) {
                        snackBar('Please enter a valid email.');
                        setState(() {
                          _isLoading = false;
                        });
                        return;
                      }

                      // Validate password match
                      if (_passwordController.text != _confirmPasswordController.text) {
                        snackBar('Passwords do not match');
                        setState(() {
                          _isLoading = false;
                        });
                        return;
                      }

                      // Save data to Firebase
                      var doc =  await FirebaseFirestore.instance.collection('users').add({
                        'email': _emailController.text,
                        'fullName': _fullNameController.text,
                        'password': _passwordController.text,
                        'createdAt': DateTime.now(),
                      });
                      doc.get().then((value) {
                        prefs?.setString('docId', value.id);
                      });
                      // Notify success and navigate
                      snackBar('Sign Up Successful');
                      setState(() {
                        _isLoading = false;
                      });
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
          if (_isLoading)
            ModalBarrier(
              color: Colors.black.withOpacity(0.5),
              dismissible: false,
            ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
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