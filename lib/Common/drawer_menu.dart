import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:printit_app/Api/Request/WSLogoutRequest.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Home/home_page.dart';
import 'package:printit_app/LogIn/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class DrawerMenu extends StatefulWidget {
  final loginStatus;
  DrawerMenu(this.loginStatus);
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  var get_print_type;
  var user_id;
  var languageType;
  bool loginStatus = false;
  @override
  void initState() {
    getValuesSF();
    super.initState();
  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginStatus = prefs.getBool('isLoggedIn') ?? false;
    var getLang = json.decode(prefs.getString('language_select')??'');
    languageType = getLang ?? 'english';
    if (loginStatus == true) {
      setState(
        () {
          loginStatus = loginStatus;
          // user_id = json.decode(prefs.getString('login_user_id'));
          get_print_type = json.decode(prefs.getString('set_print_type')??'');
          // languageType = getLang == null ? 'english' : getLang;
        },
      );
    } else {
      this.setState(() {});
    }
  }

  void logoutUser() async {
    SharedPreferences prefsd = await SharedPreferences.getInstance();
    user_id = json.decode(prefsd.getString('login_user_id')??'');

    var deviceToken = "deviceToken";
    if(Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceToken = androidInfo.id;
    }

    // progressHUD.state.show();
    var otpRequest = WSLogoutRequest(
      endPoint: APIManagerForm.endpoint,
      user_id: user_id,
      deviceToken: deviceToken,
    );
    await APIManagerForm.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        prefsd.remove('login_user_id');
        prefsd?.setBool("isLoggedIn", false);
        prefsd?.setString("language_select", json.encode('english'));
        // progressHUD.state.dismiss();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Login(comeFrom: 'newUser'),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        var messages = dataResponse['msg'];
        // progressHUD.state.dismiss();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text('Message'),
              content: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                  widthSizedBox(5.0),
                  Text(
                    'messages',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              actions: <Widget>[
                // FlatButton(
                //   child: new Text("OK"),
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                // ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
    // Future.delayed(
    //   Duration(seconds: 1),
    //   () {
    //     progressHUD.state.dismiss();
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => Login(),
    //       ),
    //       (Route<dynamic> route) => false,
    //     );
    //   },
    // );
  }

  List<Map> drawerItems = [
    {
      'icon': 'assets/icons/home_icon.png',
      'title': 'HOME',
      'arabicTitle': 'الصفحة الريئسية',
      'onPress': '/homePage',
    },
    // {
    //   'icon': 'assets/icons/printt_houses_white.png',
    //   'title': 'PRINTERIES',
    //   'onPress': '/customPrint',
    // },
    {
      'icon': 'assets/icons/design_icon.png',
      'title': 'ORDERS',
      'arabicTitle': 'الطلبات',
      'onPress': '/ordersPage',
    },
    {
      'icon': 'assets/icons/settings_icon.png',
      'title': 'SETTINGS',
      'arabicTitle': 'الإعدادات',
      'onPress': '/settings',
    },
    {
      'icon': 'assets/icons/account_icon.png',
      'title': 'ACCOUNT',
      'arabicTitle': 'ACCOUNT',
      'onPress': '/accountInfo',
    },
    {
      'icon': 'assets/icons/profile_icon.png',
      'title': 'ABOUT PRINT-IT',
      'arabicTitle': "قم بالطباعة الآن  عن الشركة",
      'onPress': '/aboutPrintIt',
    },
  ];
  List<Map> drawerItemsWithoutLogin = [
    {
      'icon': 'assets/icons/home_icon.png',
      'title': 'HOME',
      'arabicTitle': 'الصفحة الريئسية',
      'onPress': '/homePage',
    },
    {
      'icon': 'assets/icons/settings_icon.png',
      'title': 'SETTINGS',
      'arabicTitle': 'الإعدادات',
      'onPress': '/settings',
    },
    {
      'icon': 'assets/icons/profile_icon.png',
      'title': 'ABOUT PRINT-IT',
      'arabicTitle': "قم بالطباعة الآن  عن الشركة",
      'onPress': '/aboutPrintIt',
    },
  ];

  @override
  Widget build(BuildContext context) {
    print('language get drawer ${loginStatus}');
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff2995cc),
                Color(0xff29adcc),
              ],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
              tileMode: TileMode.repeated,
            ),
          ),
          padding: EdgeInsets.only(top: 65, bottom: 70, left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: whiteColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        HomePage.routeName,
                        (Route<dynamic> route) => false,
                        arguments: {'print_type': get_print_type},
                      );
                    },
                  ),
                  widthSizedBox(30.0),
                  Image.asset(
                    'assets/images/printit_logo.png',
                    height: 25.0,
                    width: 250.0,
                  )
                ],
              ),
              loginStatus || widget.loginStatus
                  ? Column(
                      children: drawerItems
                          .map(
                            (element) => Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                top: 10.0,
                                bottom: 20.0,
                              ),
                              child: GestureDetector(
                                onTap: () => element['onPress'] != null
                                    ? element['title'] == 'HOME'
                                        ? Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                            HomePage.routeName,
                                            (Route<dynamic> route) => false,
                                            arguments: {
                                              'print_type': get_print_type
                                            },
                                          )
                                        : Navigator.pushNamed(
                                            context, element['onPress'])
                                    : {},
                                child: Row(
                                  children: [
                                    Image.asset(
                                      element['icon'],
                                      height: 32,
                                      width: 32,
                                    ),
                                    widthSizedBox(10.0),
                                    Text(
                                      languageType == 'arabic'
                                          ? element['arabicTitle']
                                          : element['title'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : Column(
                      children: drawerItemsWithoutLogin
                          .map(
                            (element) => Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                top: 10.0,
                                bottom: 20.0,
                              ),
                              child: GestureDetector(
                                onTap: () => element['onPress'] != null
                                    ? element['title'] == 'HOME'
                                        ? Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                            HomePage.routeName,
                                            (Route<dynamic> route) => false,
                                            arguments: {
                                              'print_type': get_print_type
                                            },
                                          )
                                        : Navigator.pushNamed(
                                            context, element['onPress'])
                                    : {},
                                child: Row(
                                  children: [
                                    Image.asset(
                                      element['icon'],
                                      height: 32,
                                      width: 32,
                                    ),
                                    widthSizedBox(10.0),
                                    Text(
                                      languageType == 'arabic'
                                          ? element['arabicTitle']
                                          : element['title'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
              loginStatus || widget.loginStatus
                  ? GestureDetector(
                      onTap: () => logoutUser(),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/log_out_icon.png',
                            height: 40,
                            width: 35,
                          ),
                          Text(
                            languageType == 'arabic' ? 'تسجيل خروج' : 'LOGOUT',
                            style: TextStyle(
                              fontSize: 18,
                              color: whiteColor,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        // progressHUD,
      ],
    );
  }
}
