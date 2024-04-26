import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void>? _launched;

Future<void> _makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget printItImg(context) {
  return Container(
    alignment: Alignment.topCenter,
    child: Image.asset(
      'assets/images/printit_logo.png',
      width: MediaQuery.of(context).size.width * 0.3,
      fit: BoxFit.fill,
    ),
  );
}

Widget appVersion(context) {
  return Text(
    'v 1.0',
    style: TextStyle(
      fontSize: 15.0,
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w400,
      color: whiteColor,
    ),
  );
}

Widget instaWebView(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          _launched = _makePhoneCall(
            'http://www.instagram.com/g.o.u.r_31/',
          );
        },
        child: Image.asset(
          'assets/images/instagram@3x.png',
          height: 35.0,
        ),
      ),
      widthSizedBox(25.0),
      GestureDetector(
        onTap: () {
          _launched = _makePhoneCall(
            'https://flutter.dev/',
          );
        },
        child: Image.asset(
          'assets/images/globe@3x.png',
          height: 35.0,
        ),
      ),
    ],
  );
}
