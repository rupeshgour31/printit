import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/LogIn/login_model.dart';
import 'package:printit_app/LogIn/login_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final comeFrom;
  Login({this.comeFrom});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var languageType;
  void initState() {
    getValuesSF();
    super.initState();
  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var getLang = json.decode(prefs.getString('language_select')??'');
    languageType = getLang ?? 'english';
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginModel>(
      builder: (context, model, _) {
        return MediaQuery(
          data: mediaText(context),
          child: Scaffold(
            body: Stack(
              children: [
                Image.asset(
                  'assets/images/img1.png',
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 1.0,
                  fit: BoxFit.fill,
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      children: <Widget>[
                        heightSizedBox(30.0),
                        topImage(model, context),
                        heightSizedBox(30.0),
                        signInEmail(model),
                        signInPassword(model),
                        heightSizedBox(30.0),
                        submitBtn(
                          context,
                          model,
                          formKey,
                          widget.comeFrom,
                          languageType,
                        ),
                        heightSizedBox(20.0),
                        forgotPassword(context, languageType),
                        heightSizedBox(50.0),
                        dontHaveAccount(context, languageType),
                        heightSizedBox(135.0),
                        widget.comeFrom == 'newUser'
                            ? continueAsGuest(context)
                            : Container(),
                      ],
                    ),
                  ),
                ),
                // progressHUD,
              ],
            ),
          ),
        );
      },
    );
  }
}
