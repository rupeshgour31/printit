import 'package:flutter/material.dart';
import 'package:printit_app/Api/Request/WSUpdateProfileRequest.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/toast.dart';
import 'package:provider/provider.dart';

class AccountInfoModel extends ChangeNotifier {
  Color genderFieldColor = whiteColor;
  bool _obscureGender = false;
  bool _obscureGenderFemale = true;
  String seGender = '';
  bool get obscureGenderFemale => _obscureGenderFemale;
  bool get obscureGenderMale => _obscureGender;
  TextEditingController editGenderController = TextEditingController();
  TextEditingController editFirstNameController = TextEditingController();
  TextEditingController editMiddleNameController = TextEditingController();
  TextEditingController editLastNameController = TextEditingController();
  TextEditingController editNumberController = TextEditingController();
  selectGender(String type) {
    print('sdfsdf ${type}');
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

  setValues(accountInfo) {
    // var getGenter = accountInfo['gender'];
    // if (getGenter == 'female') {
    //   _obscureGenderFemale = true;
    //   _obscureGender = false;
    // } else {
    //   _obscureGender = true;
    //   _obscureGenderFemale = false;
    // }
    // editLastNameController.text = accountInfo['lastname'];
    // editNumberController = TextEditingController(text: accountInfo['mobile']);
    // notifyListeners();
  }

  submit(context, user_id, accountInfo) async {
    // progressHUD.state.show();
    var otpRequest = WSUpdateProfileRequest(
      endPoint: APIManagerForm.endpoint,
      userId: user_id.toString(),
      fName: editFirstNameController.text.isEmpty
          ? accountInfo['firstname']
          : editFirstNameController.text,
      lName: editLastNameController.text.isEmpty
          ? accountInfo['lastname']
          : editLastNameController.text,
      mobile: editNumberController.text.isEmpty
          ? accountInfo['mobile']
          : editNumberController.text,
      gender: _obscureGenderFemale ? 'female' : 'male',
    );
    await APIManagerForm.performRequest(otpRequest, showLog: true);

    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        // progressHUD.state.dismiss();
        Constants.showToast('Profile updated successfully.');
        Navigator.pop(context);
        editFirstNameController.clear();
        editLastNameController.clear();
        editNumberController.clear();
        notifyListeners();
      } else {
        // progressHUD.state.dismiss();
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
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
