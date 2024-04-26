import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'logout_model.dart';

class Logout extends StatefulWidget {
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var logoutModel = LogoutModel();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        logoutModel.Logout(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: mediaText(context),
      child: Stack(
        children: <Widget>[
          // Scaffold(
          //   backgroundColor: whiteColor,
          //   key: _scaffoldKey,
          // ),
          // progressHUD,
        ],
      ),
    );
  }
}
