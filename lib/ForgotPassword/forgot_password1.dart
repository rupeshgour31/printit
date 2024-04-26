import 'dart:async';

import 'package:flutter/material.dart';
import 'package:printit_app/Api/Request/WSResetPasswordRequest.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/toast.dart';
import 'package:printit_app/ForgotPassword/forgot_password_model.dart';
import 'package:printit_app/ForgotPassword/forgot_password_widgets.dart';
import 'package:provider/provider.dart';

class ForgotPassword1 extends StatefulWidget {
  @override
  _ForgotPassword1State createState() => _ForgotPassword1State();
}

class _ForgotPassword1State extends State<ForgotPassword1> {
  final formKey = GlobalKey<FormState>();
  resetPassword(email) async {
    // progressHUD.state.show();
    var otpRequest = WSResetPasswordRequest(
      endPoint: APIManagerForm.endpoint,
      email: email.text,
    );
    await APIManagerForm.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        // progressHUD.state.dismiss();
        email.clear();
        Constants.showToast('Please check mail for reset your password.');
        Timer(
          Duration(seconds: 3),
          () {
            Navigator.pop(context);
          },
        );
        // Navigator.pushNamed(context, '/forgotPassword2');
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
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(right: 50.0),
                      height: 50,
                      child: Text(
                        'messages',
                        // textAlign: TextAlign.center,
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
               /* FlatButton(
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ForgotPasswordModel>(
      builder: (context, model, _) {
        return MediaQuery(
          data: mediaText(context),
          child: Scaffold(
            appBar: commonAppbar(
              'Reset Password',
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
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            forgotText(),
                            forgotPasswordEmail(model),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // progressHUD,
              ],
            ),
            bottomNavigationBar:
                nextBtn(context, formKey, model, resetPassword),
          ),
        );
      },
    );
  }
}
