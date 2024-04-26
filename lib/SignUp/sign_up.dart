import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/SignUp/sign_up_model.dart';
import 'package:printit_app/SignUp/sign_up_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_google_places/flutter_google_places.dart';



class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var languageType;
  void initState() {
    getValuesSF();
    super.initState();
  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var getLang = json.decode(prefs.getString('language_select')!);
    languageType = getLang ?? 'english';
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpModel>(
      builder: (context, model, _) {
        return MediaQuery(
          data: mediaText(context),
          child: Scaffold(
            appBar: commonAppbar(
              languageType == 'arabic' ? 'التسجيل' : 'Sign Up',
              context,
              Text(
                '----------',
                style: TextStyle(
                  fontFamily: 'Nunito',
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
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              signUpFirstName(model),
                              signUpLastName(model),
                              signUpEmail(model),
                              signUpMobile(model),
                              signUpPassword(model),
                              signUpAddress(model),
                              heightSizedBox(50.0),
                              doneSignUp(context, formKey, model, languageType),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // progressHUD,
              ],
            ),
            // bottomNavigationBar: doneSignUp(context, formKey, model),
          ),
        );
      },
    );
  }
}
