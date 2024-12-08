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
      body: Padding(
        padding: EdgeInsets.only(top: mq.size.height * 0.05 ,bottom: mq.size.height * 0.1,left: mq.size.width * 0.06,right: mq.size.width * 0.06),
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
                        onTap: () {
                        },
                        child: Text('Random person', style: TextStyle(fontSize: 20, color: buttonColor)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Email', style: TextStyle(fontSize: 20)),
                      InkWell(
                        onTap: () {
                        },
                        child: Text('Random mail', style: TextStyle(fontSize: 20, color: buttonColor)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Password', style: TextStyle(fontSize: 20)),
                      InkWell(
                        onTap: () {
                        },
                        child: Text('Change Password', style: TextStyle(fontSize: 20, color: buttonColor)),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      prefs?.setBool('isLoggedIn', false);
                      Navigator.popUntil(context, (route) => route.isFirst);
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
    );
  }
}
