import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/LogIn/login.dart';
import 'package:provider/provider.dart';

class LogoutModel with ChangeNotifier {
  Future<dynamic> logout(context) async {
    return;
  }

  Logout(context) async {
    progressHUD.state.show();
    notifyListeners();
    // await Provider.of<LogoutModel>(context).logout(context);
    progressHUD.state.dismiss();
    notifyListeners();

    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(
        builder: (context) => new Login(),
      ),
      (_) => false,
    );
  }
}
