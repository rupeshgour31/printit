import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_widgets.dart';

Widget commonAppbar(String title, BuildContext context, suffixIcon) {
  return PreferredSize(
    preferredSize: Size.fromHeight(80),
    child: Padding(
      padding: EdgeInsets.only(top: 65.0, left: 20.0, right: 20.0),
      child: AppBar(
        backgroundColor: Colors.black45,
        automaticallyImplyLeading: false,
        flexibleSpace: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: whiteColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 23.0,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w400,
                  color: whiteColor,
                ),
              ),
              suffixIcon
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80.0),
        ),
      ),
    ),
  );
}
