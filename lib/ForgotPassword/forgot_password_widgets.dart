import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/my_text_field.dart';
import 'package:printit_app/Common/validations_field.dart';
import 'package:printit_app/ForgotPassword/forgot_password_model.dart';
import 'package:provider/provider.dart';

Widget forgotText() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Enter ',
        style: TextStyle(
          fontSize: 25.0,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
          color: whiteColor,
        ),
        maxLines: 2,
      ),
      Text(
        'Your Email',
        style: TextStyle(
          fontSize: 25.0,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
          color: whiteColor,
        ),
        maxLines: 2,
      ),
    ],
  );
}

Widget newPasswordText() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Type ',
        style: TextStyle(
          fontSize: 25.0,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
          color: whiteColor,
        ),
        maxLines: 2,
      ),
      Text(
        'A new password',
        style: TextStyle(
          fontSize: 25.0,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
          color: whiteColor,
        ),
        maxLines: 2,
      ),
    ],
  );
}

Widget forgotPasswordEmail(model) {
  return AllInputDesign(
    key: Key("email"),
    controller: model.forgotEmail,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'email',
    onChanged: (email) {},
    validator: validateEmailField,
    textInputAction: TextInputAction.done,
    keyBoardType: TextInputType.text,
  );
}

Widget enterPassword(model) {
  return AllInputDesign(
    // key: Key("password"),
    controller: model.enterChangedPassword,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'password',
    obsecureText: true,
    onSaved: (String? val) {},
    onChanged: (value) {},
    // validatorFieldValue: 'password',
    validator: validatePassword,
    textInputAction: TextInputAction.done,
    keyBoardType: TextInputType.text,
  );
}

Widget enterPasswordAgain(model) {
  return AllInputDesign(
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'confirm password',
    obsecureText: true,
    validator: (val) {
      if (val.isEmpty) return 'Confirm Password is Required.';
      if (val != model.enterChangedPassword.text)
        return 'Confirm Password must be match with Password';
      return null;
    },
    onChanged: (email) {},
    // validator: validateEmailField,
    textInputAction: TextInputAction.done,
    keyBoardType: TextInputType.text,
  );
}

Widget nextBtn(context, formKey, model, resetPassword) {
  return InkWell(
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/img1.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Color(0xff2995cc),
        ),
        child: Center(
          child: Text(
            'NEXT',
            style: TextStyle(
              fontSize: 25.0,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
              color: whiteColor,
            ),
          ),
        ),
      ),
    ),
    onTap: () {
      if (formKey.currentState.validate()) {
        resetPassword(model.forgotEmail);
      }
    },
  );
}

Widget submitBtn(context, formKey, model, forgotPassReq) {
  return GestureDetector(
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/img1.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Color(0xff2995cc),
        ),
        child: Center(
          child: Text(
            'DONE',
            style: TextStyle(
              fontSize: 25.0,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
              color: whiteColor,
            ),
          ),
        ),
      ),
    ),
    onTap: () {
      if (formKey.currentState.validate()) {
        forgotPassReq(context);
      }
    },
  );
}
