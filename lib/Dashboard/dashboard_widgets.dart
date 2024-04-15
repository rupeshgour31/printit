import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/my_text_field.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

Widget userName() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Hello',
        style: TextStyle(
          fontSize: 18.0,
          color: whiteColor,
        ),
      ),
      Text(
        'Mr. Fadi Ameer',
        style: TextStyle(
          fontSize: 18.0,
          color: whiteColor,
        ),
      ),
    ],
  );
}

Widget accInfoEmail(model) {
  return AllInputDesign(
    key: Key("Email"),
    // controller: model.loginEmail,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Email',
    validatorFieldValue: 'Email',
    // validator: loginvalidation.validateUsernameField,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget accInfoFirstName(model) {
  return AllInputDesign(
    key: Key("First Name"),
    // controller: model.loginEmail,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'First Name',
    validatorFieldValue: 'First Name',
    // validator: loginvalidation.validateUsernameField,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget accInfoMiddleName(model) {
  return AllInputDesign(
    key: Key("Middle Name"),
    // controller: model.loginEmail,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Middle Name',
    validatorFieldValue: 'Middle Name',
    // validator: loginvalidation.validateUsernameField,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget accInfoLastName(model) {
  return AllInputDesign(
    key: Key("Last Name"),
    // controller: model.loginEmail,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Last Name',
    validatorFieldValue: 'Last Name',
    // validator: loginvalidation.validateUsernameField,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget accInfoMobile(model) {
  return AllInputDesign(
    key: Key("Mobile Number"),
    // controller: model.loginEmail,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Mobile Number',
    validatorFieldValue: 'Mobile Number',
    // validator: loginvalidation.validateUsernameField,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget genderText() {
  return Text(
    'Gender',
    style: TextStyle(
      fontSize: 18.0,
      color: whiteColor,
    ),
  );
}

Widget genderField(model) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      GestureDetector(
        onTap: () {
          model.selectGender('male');
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: 85.0,
          height: 85.0,
          decoration: BoxDecoration(
            color: model.obscureGenderMale ? Color(0xff2995cc) : whiteColor,
            borderRadius: BorderRadius.circular(17.0),
            border: Border.all(color: Colors.grey),
          ),
          child: model.obscureGenderMale
              ? Image.asset(
                  'assets/images/image1.png',
                )
              : Image.asset(
                  'assets/images/image3.png',
                ),
        ),
      ),
      widthSizedBox(12.0),
      GestureDetector(
        onTap: () {
          model.selectGender('female');
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: 85.0,
          height: 85.0,
          decoration: BoxDecoration(
            color: model.obscureGenderFemale ? Color(0xff2995cc) : whiteColor,
            borderRadius: BorderRadius.circular(17.0),
            border: Border.all(color: Colors.grey),
          ),
          child: model.obscureGenderFemale
              ? Image.asset('assets/images/image4.png')
              : Image.asset('assets/images/image2.png'),
        ),
      ),
    ],
  );
}

Widget updateAccount(context, model) {
  return GestureDetector(
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
          'UPDATE',
          style: TextStyle(
            fontSize: 25.0,
            color: whiteColor,
          ),
        ),
      ),
    ),
    onTap: () {
      // if (formKey.currentState.validate()) {
      //   model.submit(context);
      // }
    },
  );
}
