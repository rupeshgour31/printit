import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:printit_app/Common/drawer_menu.dart';
import 'package:printit_app/Dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/homePage';
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   bool loginStatus;
//   @override
//   void initState() {
//     getValuesSF();
//     super.initState();
//   }
//
//   @override
//   getValuesSF() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var Status = prefs.getBool('isLoggedIn') ?? false;
//     setState(
//       () {
//         loginStatus = Status;
//       },
//     );
//   }

  @override
  Widget build(BuildContext context) {
    final Map product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Stack(
        children: [
          DrawerMenu(product['loginStatus']?? true),
          Dashboard(getPrintType: product['print_type']),
        ],
      ),
    );
  }
}
