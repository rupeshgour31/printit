import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printit_app/AboutPrintIt/about_widgets.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Home/home_page.dart';
import 'package:printit_app/Settings/SavedAddress/savedAddresses.dart';
import 'package:printit_app/Settings/settings_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'dart:core';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _platformVersion = 'Unknown';

  Future<void> _launched;
  String _phone = '';
  var user_id;
  var get_print_type;
  var languageType;
  bool loginStatus = false;
  void initState() {
    super.initState();
    getValuesSF();
  }

  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginStatus = prefs.getBool('isLoggedIn') ?? false;
    var getLang = json.decode(prefs.getString('language_select'));
    languageType = getLang == null ? 'english' : getLang;
    if (loginStatus) {
      setState(
        () {
          user_id = json.decode(prefs.getString('login_user_id'));
          get_print_type = json.decode(prefs.getString('set_print_type'));
        },
      );
    }
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

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  bool btn1 = true;
  bool btn2 = false;
  void btnTap(String btnType) async {
    if (btnType == 'btn1') {
      setState(() {
        btn1 = true;
        btn2 = false;
        languageType = 'english';
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
        'language_select',
        json.encode('english'),
      );
      this.setState(() {});
    } else {
      setState(() {
        btn1 = false;
        btn2 = true;
        languageType = 'arabic';
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
        'language_select',
        json.encode('arabic'),
      );
      this.setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    print('language gets ${languageType}');
    return Scaffold(
      appBar: PreferredSize(
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
                      Navigator.of(context).pushNamed(
                        HomePage.routeName,
                        arguments: {'print_type': get_print_type},
                      );
                    },
                  ),
                  Text(
                    languageType == 'arabic' ? 'الإعدادات' : 'Settings',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400,
                      color: whiteColor,
                    ),
                  ),
                  Text(
                    '----------',
                    style: TextStyle(
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80.0),
            ),
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
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  heightSizedBox(10.0),
                  // commonListTile(
                  //   'Account Info',
                  //   () {
                  //     Navigator.pushNamed(context, '/accountInfo');
                  //   },
                  // ),
                  // heightSizedBox(10.0),
                  if (loginStatus == true)
                    commonListTile(
                      'Change Password',
                      () {
                        Navigator.pushNamed(context, '/resetPassword');
                      },
                    ),
                  heightSizedBox(10.0),
                  // commonListTile(
                  //   'Saved Addresses',
                  //   () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => SavedAddresses(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  // heightSizedBox(10.0),
                  commonListTile(
                    'Notifications Settings',
                    () {},
                  ),
                  heightSizedBox(10.0),
                  commonListTile(
                    languageType == 'arabic' ? "تواصل معنا" : 'Contact Us',
                    () {
                      contactUsPopup(context);
                    },
                  ),
                  heightSizedBox(10.0),
                  commonListTile(
                    languageType == 'arabic' ? "عن الشركة" : 'About Print it',
                    () {
                      Navigator.pushNamed(context, '/aboutPrintIt');
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
                    languageType == 'arabic' ? "الإجمالية" : 'Privacy Policy',
                    () {
                      Navigator.pushNamed(context, '/privacyPolicy');
                    },
                  ),
                  heightSizedBox(30.0),
                  languageBtn(
                    context,
                    btnTap,
                    btn1,
                    btn2,
                    languageType,
                  ),
                  heightSizedBox(30.0),
                  printItImg(context),
                  heightSizedBox(10.0),
                  appVersion(context),
                  heightSizedBox(60.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget contactUsPopup(context) {
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
                        _launched = _makePhoneCall(
                          'tel: +91 76970054659',
                        );
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
                        FlutterOpenWhatsapp.sendSingleMessage(
                            "7697005469", "Hello");
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
                        _launched = _makePhoneCall(
                          _emailLaunchUri.toString(),
                        );
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
