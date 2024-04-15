import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:provider/provider.dart';

class AccountInfoModel extends ChangeNotifier {
  Color genderFieldColor = whiteColor;
  bool _obscureGender = false;
  bool _obscureGenderFemale = true;
  String seGender;
  bool get obscureGenderFemale => _obscureGenderFemale;
  bool get obscureGenderMale => _obscureGender;

  selectGender(String type) {
    seGender = type;
    if (type == 'male') {
      _obscureGender = true;
      _obscureGenderFemale = false;
    } else {
      _obscureGenderFemale = true;
      _obscureGender = false;
    }
    notifyListeners();
  }

  void initTask(context) async {
    _obscureGender = true;
    _obscureGenderFemale = true;
    notifyListeners();
    new Future.delayed(
      Duration.zero,
      () async {
        notifyListeners();
      },
    );
  }
}
