import 'package:flutter/material.dart';
import 'package:printit_app/Common/button.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/my_text_field.dart';
import 'package:printit_app/Common/validations_field.dart';
import 'package:printit_app/Dashboard/service_select.dart';

Widget topImage(model, context) {
  return GestureDetector(
    child: Container(
      alignment: Alignment.topCenter,
      child: Image.asset(
        'assets/images/printit_logo.png',
        width: MediaQuery.of(context).size.width * 0.5,
        fit: BoxFit.fill,
      ),
    ),
    onTap: () {
      Navigator.pushNamed(context, '/poster');
    },
  );
}

Widget signInEmail(model) {
  return AllInputDesign(
    key: Key("email"),
    controller: model.loginEmail,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Email',
    validatorFieldValue: 'email',
    // validator: validateEmailField,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget signInPassword(model) {
  return AllInputDesign(
    key: Key("password"),
    controller: model.loginPassword,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'password',
    obsecureText: model.obscureText,
    suffixIcon: GestureDetector(
      key: Key('password_visibility'),
      child: Icon(
        model.obscureText ? Icons.visibility : Icons.visibility_off,
        size: 20.0,
        color: whiteColor,
      ),
      onTap: () {
        model.toggle();
      },
    ),
    validatorFieldValue: 'password',
    // validator: validatePassword,
    keyBoardType: TextInputType.text,
  );
}

Widget submitBtn(
  BuildContext context,
  model,
  formKey,
  comeFrom,
  languageType,
) {
  return Button(
    buttonName: languageType == 'arabic' ? 'دخول الحساب' : 'Login',
    key: Key('login_submit'),
    decoration: BorderRadius.circular(15.0),
    btnColor: Color(0xff2995cc),
    color: Color(0xff2995cc),
    onPressed: () {
      if (formKey.currentState.validate()) {
        model.signInRequest(context, comeFrom);
      }
    },
  );
}

Widget forgotPassword(context, languageType) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        key: Key('forget_passwordkey'),
        onTap: () {
          Navigator.pushNamed(context, '/forgotPassword1');
        },
        child: Text(
          languageType == 'arabic'
              ? 'نسيت رمز المرور الخاص بك'
              : 'FORGOT PASSWORD',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w400,
            color: whiteColor,
          ),
        ),
      ),
    ],
  );
}

Widget dontHaveAccount(context, languageType) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        languageType == 'arabic'
            ? 'ليس لديك حساب بعد؟'
            : 'Don\'t have an account?',
        style: TextStyle(
          fontSize: 15.0,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
          color: whiteColor,
        ),
      ),
      heightSizedBox(10.0),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/signUp');
        },
        child: Text(
          languageType == 'arabic' ? 'التسجيل' : 'SIGNUP',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w400,
            color: whiteColor,
          ),
        ),
      ),
    ],
  );
}

Widget continueAsGuest(context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceSelect(),
        ),
      );
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'CONTINUE AS GUEST',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w400,
            color: whiteColor,
          ),
        ),
      ],
    ),
  );
}
