import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/my_text_field.dart';

Widget userName(accountInfo, model) {
  if (accountInfo != null) {
    model.setValues(accountInfo);
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Hello',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
          color: whiteColor,
        ),
      ),
      accountInfo != null
          ? Text(
              // '',
              '${accountInfo['firstname']} ${accountInfo['lastname']}' ?? '',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
                color: whiteColor,
              ),
            )
          : Text(''),
    ],
  );
}

Widget accInfoEmail(accountInfo) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(left: 15.0),
    height: 50,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Color(0XFFF3F3F3).withOpacity(0.12),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Color(0XFFF3F3F3),
      ),
    ),
    child: Text(
      accountInfo != null ? accountInfo['email'] : 'Email',
      style: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 17,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}

Widget accInfoFirstName(model, accountInfo) {
  return AllInputDesign(
    key: Key("First Name"),
    controller: model.editFirstNameController,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: accountInfo != null ? accountInfo['firstname'] : '',
    validatorFieldValue: 'First Name',
    // validator: loginvalidation.validateUsernameField,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget accInfoMiddleName(model) {
  return AllInputDesign(
    key: Key("Middle Name"),
    controller: model.editMiddleNameController,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Middle Name',
    validatorFieldValue: 'Middle Name',
    // validator: loginvalidation.validateUsernameField,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget accInfoLastName(model, accountInfo) {
  return AllInputDesign(
    key: Key("Last Name"),
    controller: model.editLastNameController,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: accountInfo != null ? accountInfo['lastname'] : 'Last Name',
    validatorFieldValue: 'Last Name',
    // validator: loginvalidation.validateUsernameField,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget accInfoMobile(model, accountInfo) {
  return AllInputDesign(
    key: Key("Mobile Number"),
    controller: model.editNumberController,
    fillColor: Colors.grey.withOpacity(0.2),
    maxLength: 8,
    hintText: accountInfo != null ? accountInfo['mobile'] : '',
    validatorFieldValue: 'Mobile Number',
    prefixText: '+965 ',
    // prefixIcon
    prefixStyle: TextStyle(
      fontSize: 17,
      color: Colors.grey.shade400,
    ),
    // validator: loginvalidation.validateUsernameField,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget genderText() {
  return Text(
    'Gender',
    style: TextStyle(
      fontSize: 18.0,
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w400,
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

Widget updateAccount(context, model, userId, accountInfo) {
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
            'UPDATE',
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
      model.submit(context, userId, accountInfo);
    },
  );
}
