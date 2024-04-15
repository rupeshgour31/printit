import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:printit_app/Dashboard/service_select.dart';
import 'package:printit_app/Home/home_page.dart';
import 'dart:async';

import 'package:printit_app/LogIn/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getValuesSF();
  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    if (prefs.containsKey('language_select')) {
    } else {
      prefs.setString(
        'language_select',
        json.encode('english'),
      );
    }
    Timer(
      Duration(seconds: 3),
      () {
        status
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceSelect(),
                ),
                (Route<dynamic> route) => false,
              )
            : Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(comeFrom: 'newUser'),
                ),
                (Route<dynamic> route) => false,
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        height: MediaQuery.of(context).size.height * 1.0,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Image.asset(
              'assets/images/img1.png',
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 1.0,
              fit: BoxFit.fill,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1.0,
              child: Center(
                child: Image.asset(
                  'assets/images/printit_logo.png',
                  width: MediaQuery.of(context).size.width * 0.5,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
