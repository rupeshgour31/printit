import 'package:flutter/material.dart';

class ForgotPasswordModel extends ChangeNotifier {
  TextEditingController forgotEmail = TextEditingController();
  TextEditingController enterChangedPassword = TextEditingController();
  bool autoValidate = false;

  submit(context) async {
    print('ruepsh');
    notifyListeners();
  }
}
