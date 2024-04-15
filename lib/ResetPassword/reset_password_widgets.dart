import 'package:flutter/material.dart';
import 'package:printit_app/Common/button.dart';
import 'package:printit_app/Common/my_text_field.dart';
import 'package:printit_app/Common/validations_field.dart';

TextEditingController changePassOldOne = TextEditingController();
TextEditingController changePassNewOne = TextEditingController();
Widget enterOldPassword() {
  return AllInputDesign(
    // key: Key("password"),
    controller: changePassOldOne,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'old password',
    obsecureText: true,
    onSaved: (String val) {},
    onChanged: (value) {},
    // validatorFieldValue: 'password',
    validator: validatePassword,
    textInputAction: TextInputAction.done,
    keyBoardType: TextInputType.text,
  );
}

Widget enterPassword() {
  return AllInputDesign(
    // key: Key("password"),
    controller: changePassNewOne,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'new password',
    obsecureText: true,
    onSaved: (String val) {},
    onChanged: (value) {},
    // validatorFieldValue: 'password',
    validator: validateNewPassword,
    textInputAction: TextInputAction.done,
    keyBoardType: TextInputType.text,
  );
}

Widget enterPasswordAgain() {
  return AllInputDesign(
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'confirm new password',
    obsecureText: true,
    validator: (val) {
      if (val.isEmpty) return 'Confirm Password is Required.';
      if (val != changePassNewOne.text)
        return 'Confirm Password must be match with Password';
      return null;
    },
    onChanged: (email) {},
    // validator: validateEmailField,
    textInputAction: TextInputAction.done,
    keyBoardType: TextInputType.text,
  );
}

Widget changePasswordBtn(formKey, context, submitResetPassword) {
  return Button(
    btnHeight: 50.0,
    btnWidth: double.infinity,
    buttonName: 'CHANGE PASSWORD',
    color: Color(0xff2995cc),
    btnColor: Color(0xff2995cc),
    decoration: BorderRadius.circular(30.0),
    onPressed: () {
      if (formKey.currentState.validate()) {
        submitResetPassword();
      }
    },
  );
}
