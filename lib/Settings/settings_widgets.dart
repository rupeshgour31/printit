import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:printit_app/Common/button.dart';
import 'package:printit_app/Common/common_widgets.dart';

Widget commonListTile(String prefixText, onPressed) {
  return ListTile(
    onTap: onPressed,
    title: Text(
      prefixText,
      style: TextStyle(
        fontSize: 18.0,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w400,
        color: whiteColor,
      ),
    ),
    trailing: Icon(
      Icons.arrow_forward_ios_outlined,
      color: whiteColor,
    ),
  );
}

Widget languageBtn(context, btnTap, btn1, btn2, languageType) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () => btnTap('btn1'),
        child: Container(
          alignment: Alignment.center,
          height: 50,
          width: 120,
          decoration: BoxDecoration(
            color: languageType == 'english' || btn1 == true
                ? Color(0xff2995cc)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
              color: Color(0xff2995cc),
            ),
          ),
          child: Text(
            'English',
            style: TextStyle(
              color: whiteColor,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 18.0,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
      widthSizedBox(12.0),
      GestureDetector(
        onTap: () => btnTap('btn2'),
        child: Container(
          alignment: Alignment.center,
          height: 50,
          width: 120,
          decoration: BoxDecoration(
            color: languageType == 'arabic' || btn2 == true
                ? Color(0xff2995cc)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
              color: Color(0xff2995cc),
            ),
          ),
          child: Text(
            'عربي',
            style: TextStyle(
              color: whiteColor,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 18.0,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    ],
  );
}
