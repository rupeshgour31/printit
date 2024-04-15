import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:printit_app/Api/Request/WSChangePasswordRequest.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/toast.dart';
import 'package:printit_app/ResetPassword/reset_password_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formKey = GlobalKey<FormState>();
  var user_id;
  var get_print_type;
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getValuesSF();
    });
    super.initState();
  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    if (status) {
      setState(
        () {
          user_id = json.decode(prefs.getString('login_user_id'));
          get_print_type = json.decode(prefs.getString('set_print_type'));
        },
      );
    }
  }

  submitResetPassword() async {
    progressHUD.state.show();
    var otpRequest = WSChangePasswordRequest(
      endPoint: APIManagerForm.endpoint,
      userId: user_id.toString(),
      newPassword: changePassNewOne.text,
      oldPassword: changePassOldOne.text,
    );
    await APIManagerForm.performRequest(otpRequest, showLog: true);

    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        Constants.showToast('Password change successfully.');
        Navigator.pop(context);
        changePassNewOne.clear();
        changePassOldOne.clear();
        progressHUD.state.dismiss();
      } else {
        progressHUD.state.dismiss();
        var messages = dataResponse['msg'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text('Message'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                  widthSizedBox(5.0),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(right: 50.0),
                      height: 50,
                      child: Text(
                        messages,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Nunito',
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(
        'Change Password',
        context,
        Text(
          '----------',
          style: TextStyle(
            color: Colors.transparent,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/img1.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        heightSizedBox(10.0),
                        enterOldPassword(),
                        enterPassword(),
                        enterPasswordAgain(),
                        heightSizedBox(30.0),
                        changePasswordBtn(
                            formKey, context, submitResetPassword),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          progressHUD,
        ],
      ),
    );
  }
}
