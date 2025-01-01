import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app_task/Utility.dart';
import '../../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late DocumentSnapshot user;
  bool isUserLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    user = await FirebaseFirestore.instance.collection('users').doc(prefs?.getString('userId')).get();
    setState(() {
      isUserLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('TO DO LIST',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: buttonColor,
            )),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: isUserLoaded ? SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: mq.size.height * 0.05, bottom: mq.size.height * 0.1, left: mq.size.width * 0.06, right: mq.size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'lib/assets/images/rafiki.svg',
                width: mq.size.width * 1,
                height: mq.size.height * 0.35,
              ),
              SizedBox(
                height: mq.size.height * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Full name', style: TextStyle(fontSize: 20)),
                        InkWell(
                          onTap: () async {
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                title: const Text('Change Full Name'),
                                content: TextField(
                                  controller: _fullNameController,
                                  decoration: InputDecoration(
                                    enabledBorder: borderDecor(textFieldColor),
                                    border: borderDecor(textFieldColor),
                                    hintText: 'Enter new full name',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance.collection('users').doc(prefs?.getString('userId')).update({
                                        'fullName': _fullNameController.text,
                                      });
                                      _loadUserData();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              );
                            });
                          },
                          child: Text(user['fullName'], style: TextStyle(fontSize: 20, color: buttonColor)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Email', style: TextStyle(fontSize: 20)),
                        Text(user['email'], style: TextStyle(fontSize: 20, color: buttonColor)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Password', style: TextStyle(fontSize: 20)),
                        InkWell(
                          onTap: () {
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                title: const Text('Change Password'),
                                content: SizedBox(
                                  height: mq.size.height * 0.1,
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: _passwordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          enabledBorder: borderDecor(textFieldColor),
                                          border: borderDecor(textFieldColor),
                                          hintText: 'Enter new password',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance.collection('users').doc(prefs?.getString('userId')).update({
                                        'password': _passwordController.text,
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              );
                            });
                          },
                          child: Text('Change Password', style: TextStyle(fontSize: 20, color: buttonColor)),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        prefs?.setBool('isLoggedIn', false);
                        Navigator.popUntil(context, ModalRoute.withName('/signIn'));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(mq.size.width, mq.size.height * 0.07),
                        foregroundColor: Colors.white,
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(mq.size.width * 0.05),
                        ),
                      ),
                      child: const Text('LOG OUT'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}