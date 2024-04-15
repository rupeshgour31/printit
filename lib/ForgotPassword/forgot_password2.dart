import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/ForgotPassword/forgot_password_model.dart';
import 'package:printit_app/ForgotPassword/forgot_password_widgets.dart';
import 'package:provider/provider.dart';

class ForgotPassword2 extends StatefulWidget {
  @override
  _ForgotPassword2State createState() => _ForgotPassword2State();
}

class _ForgotPassword2State extends State<ForgotPassword2> {
  final formKey = GlobalKey<FormState>();
  void forgotPassReq() async {}
  @override
  Widget build(BuildContext context) {
    return Consumer<ForgotPasswordModel>(
      builder: (context, model, _) {
        return MediaQuery(
          data: mediaText(context),
          child: Scaffold(
            extendBodyBehindAppBar: true,
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
            body: Container(
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
                  autovalidate: model.autoValidate,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        newPasswordText(),
                        enterPassword(model),
                        enterPasswordAgain(model),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: submitBtn(
              context,
              formKey,
              model,
              forgotPassReq,
            ),
          ),
        );
      },
    );
  }
}
