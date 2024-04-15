import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceSelect extends StatefulWidget {
  @override
  _ServiceSelectState createState() => _ServiceSelectState();
}

class _ServiceSelectState extends State<ServiceSelect> {
  var languageType;
  var loginStatus;
  void initState() {
    getValuesSF();
    super.initState();
  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var getLang = json.decode(prefs.getString('language_select'));
    languageType = getLang ?? '0';
  }

  var setPrintType;
  void storePrintType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var logStatus = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      loginStatus = logStatus;
    });
    prefs.setString(
      'set_print_type',
      json.encode(
        setPrintType,
      ),
    );
    Navigator.of(context).pushNamedAndRemoveUntil(
      HomePage.routeName,
      (Route<dynamic> route) => false,
      arguments: {
        'print_type': setPrintType,
        'loginStatus': loginStatus,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.0),
        image: DecorationImage(
          image: AssetImage("assets/images/img1.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'Print IT',
              style: TextStyle(
                color: setPrintType == null ? whiteColor : Colors.white38,
                fontFamily: 'Nunito',
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Image.asset(
                'assets/icons/drawer.png',
                height: 30,
                width: 30.0,
                color: setPrintType == null ? whiteColor : Colors.white38,
              ),
            )),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/img1.png"),
              fit: BoxFit.cover,
            ),
          ),
          //     WidgetsBinding.instance.addPostFrameCallback((_) async {
          //       await showDialog<String>(
          //         barrierColor: Colors.black.withOpacity(0.65),
          //         barrierDismissible: true,
          //         context: context,
          //         builder: (BuildContext context) => new AlertDialog(
          //           backgroundColor: Colors.transparent,
          //           actions: <Widget>[
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  languageType == 'arabic'
                      ? 'اختر نوع الخدمة المطلوبة'
                      : 'Select Service Type.',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: whiteColor,
                    fontFamily: 'Nunito',
                    decoration: TextDecoration.none,
                  ),
                  maxLines: 3,
                  textAlign: TextAlign.start,
                ),
                heightSizedBox(25.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      setPrintType = 'express_print';
                    });
                    // Navigator.of(context).pop();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.only(left: 8.0),
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      color: setPrintType == 'express_print' ||
                              setPrintType == null
                          ? whiteColor
                          : Colors.white38,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widthSizedBox(8.0),
                        SizedBox(
                          height: 30.0,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Image.asset(
                            'assets/icons/Printit Logo@3x.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        widthSizedBox(15.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              languageType == 'arabic'
                                  ? 'برنت إت- الخدمة السريعة'
                                  : 'Print-it Express ',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Nunito',
                                decoration: TextDecoration.none,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 70.0,
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Text(
                                languageType == 'arabic'
                                    ? 'خدمات خاصة من تطبيق برنت إت مع خيار التوصيل فقط'
                                    : 'Service Provided by Print-it App with delivery option only',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                  fontFamily: 'Nunito',
                                  decoration: TextDecoration.none,
                                ),
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                heightSizedBox(20.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      setPrintType = 'local_print';
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                      color:
                          setPrintType == 'local_print' || setPrintType == null
                              ? whiteColor
                              : Colors.white54,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      children: [
                        widthSizedBox(8.0),
                        SizedBox(
                          height: 60.0,
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Image.asset(
                            'assets/icons/printt_houses_icon4.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        widthSizedBox(35.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              languageType == 'arabic'
                                  ? 'مطابع محلية'
                                  : 'Local Printeries',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Nunito',
                                decoration: TextDecoration.none,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 70.0,
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Text(
                                languageType == 'arabic'
                                    ? 'خدمات خاصة من مطبعتك المفضلة مع اختيارك لخدمة التوصيل أو الاستلام'
                                    : 'Service by your favorite printery That is available for delivery or Pickup ',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                  fontFamily: 'Nunito',
                                  decoration: TextDecoration.none,
                                ),
                                maxLines: 3,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: setPrintType != null
            ? InkWell(
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
                        languageType == 'arabic' ? 'تأكيد' : 'CONFIRM',
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
                  storePrintType();
                },
              )
            : Container(
                width: double.infinity,
                height: 65,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/img1.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ),
    );
  }
}
