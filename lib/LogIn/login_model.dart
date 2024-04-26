import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:printit_app/Api/Request/WSLoginRequest.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Common/button.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Dashboard/service_select.dart';
import 'package:printit_app/Home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginModel extends ChangeNotifier {
  bool _obscureText = true;
  bool get obscureText => _obscureText;

  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  toggle() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  void initTask(context) async {
    _obscureText = true;
    notifyListeners();
    new Future.delayed(
      Duration.zero,
      () async {
        final model = Provider.of<LoginModel>(context);
        notifyListeners();
      },
    );
  }

  signInRequest(context, comeFrom) async {
    var deviceToken = "deviceToken";
    if(Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceToken = androidInfo.id;
    }

    // progressHUD.state.show();
    var otpRequest = WSLoginRequest(
      endPoint: APIManagerForm.endpoint,
      email: loginEmail.text,
      password: loginPassword.text,
      deviceToken: deviceToken,
    );
    await APIManagerForm.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
          'login_user_id',
          json.encode(
            dataResponse['user_id'],
          ),
        );
        prefs?.setBool("isLoggedIn", true);
        // progressHUD.state.dismiss();
        if (comeFrom == 'newUser') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceSelect(),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pop(context);
        }
        loginEmail.clear();
        loginPassword.clear();
        notifyListeners();
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   HomePage.routeName,
        //   (Route<dynamic> route) => false,
        //   arguments: {'print_type': 'express_print'},
        // );
      } else {
        var messages = dataResponse['msg'];
        // progressHUD.state.dismiss();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text('Message'),
              content: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                  widthSizedBox(5.0),
                  Text(
                    'messages',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              actions: <Widget>[
                /*FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),*/
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }
}
