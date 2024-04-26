import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:printit_app/AboutPrintIt/about_widgets.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Settings/settings_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPrintIt extends StatefulWidget {
  @override
  _AboutPrintItState createState() => _AboutPrintItState();
}

class _AboutPrintItState extends State<AboutPrintIt> {
  // Future<void> _launched;
  var languageType;
  void initState() {
    getValuesSF();
    super.initState();
  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var getLang = json.decode(prefs.getString('language_select'));
    // languageType = getLang ?? 'english';
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final Uri _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'smith@example.com',
    queryParameters: {
      'subject': 'Example Subject & Symbols are allowed!',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(
        languageType == 'arabic'
            ? "قم بالطباعة الآن  عن الشركة"
            : 'About Print-It',
        context,
        Text(
          '----------',
          style: TextStyle(
            color: Colors.transparent,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/img1.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 25.0,
              right: 25.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                heightSizedBox(15.0),
                commonListTile(
                  languageType == 'arabic' ? "الإجمالية" : 'Privacy Policy',
                  () {
                    Navigator.pushNamed(context, '/privacyPolicy');
                  },
                ),
                heightSizedBox(10.0),
                commonListTile(
                  languageType == 'arabic'
                      ? 'الشروط والأحكام'
                      : 'Terms & Conditions',
                  () {
                    Navigator.pushNamed(context, '/termsAndCondition');
                  },
                ),
                heightSizedBox(10.0),
                commonListTile(
                  languageType == 'arabic' ? "تواصل معنا" : 'Contact Us',
                  () {
                    contactUsPopup(context);
                  },
                ),
                heightSizedBox(MediaQuery.of(context).size.height * 0.3),
                printItImg(context),
                heightSizedBox(10.0),
                appVersion(context),
                heightSizedBox(25.0),
                instaWebView(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

   contactUsPopup(context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: 250.0,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                height: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey[300],
                ),
                margin: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Text(
                        'Call',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        print('rupesh gour');
                        // _launched = _makePhoneCall(
                        //   'tel: +91 76970054659',
                        // );
                      },
                    ),
                    dividerCommon(
                      height: 1.0,
                      endIndent: 1.0,
                      indent: 1.0,
                      thickness: 1.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        // FlutterOpenWhatsapp.sendSingleMessage(
                        //     "7697005469", "Hello");
                      },
                      child: Text(
                        'WhatsApp',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    dividerCommon(
                      height: 1.0,
                      endIndent: 1.0,
                      indent: 1.0,
                      thickness: 1.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        print('rupesh gour');
                        // _launched = _makePhoneCall(
                        //   _emailLaunchUri.toString(),
                        // );
                      },
                      child: Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              heightSizedBox(5.0),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                height: 50.0,
                margin: EdgeInsets.only(left: 12, right: 12.0, bottom: 5.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: whiteColor,
                ),
                // margin: EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
