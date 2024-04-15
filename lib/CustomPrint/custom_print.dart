import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:printit_app/Api/Request/WSCustomPrintOptionsRequest.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/CustomPrint/custom_print_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomPrint extends StatefulWidget {
  @override
  _CustomPrintState createState() => _CustomPrintState();
}

class _CustomPrintState extends State<CustomPrint> {
  List customOptionsData = [];
  final formKey = GlobalKey<FormState>();
  bool loginStatus = false;
  var languageType;
  @override
  void initState() {
    super.initState();
    custom_print_options();
    getValuesSF();
  }

  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginStatus = prefs.getBool('isLoggedIn') ?? false;
    var getLang = json.decode(prefs.getString('language_select'));
    setState(
      () {
        languageType = getLang ?? 'english';
      },
    );
  }

  void custom_print_options() async {
    var otpRequest = WSCustomPrintOptionsRequest(
      endPoint: APIManagerForm.endpoint,
    );
    await APIManagerForm.performRequest(otpRequest, showLog: true);

    try {
      var dataResponse = otpRequest.response;

      if (dataResponse['success'] == true) {
        setState(() {
          customOptionsData = dataResponse['data'];
        });
      } else {
        var messages = dataResponse['msg'];
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
                    messages,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(
        languageType == 'arabic' ? 'مخصّصة' : 'Custom Print',
        context,
        Text(
          '----------',
          style: TextStyle(
            color: Colors.transparent,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/img1.png',
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 1.0,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 140.0),
            child: customOptionsData.length == 0
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        posterFlyerHead(
                          context,
                          customOptionsData[0]['image'],
                          customOptionsData[0]['name'].toUpperCase(),
                          () {
                            Navigator.pushNamed(context, '/poster', arguments: {
                              "printType":
                                  languageType == 'arabic' ? 'بوستر' : "Poster",
                              'order_type': '1',
                              'order_type_no': '1',
                              "imageName": 'assets/images/poster.png',
                            });
                          },
                        ),
                        heightSizedBox(30.0),
                        bannersRollUpHead(
                          context,
                          customOptionsData[3]['image'],
                          customOptionsData[3]['name'].toUpperCase(),
                          () {
                            Navigator.pushNamed(context, '/poster', arguments: {
                              "printType":
                                  languageType == 'arabic' ? 'بانير' : "Banner",
                              'order_type': '1',
                              'order_type_no': '4',
                              "imageName": 'assets/images/banner.png'
                            });
                          },
                        ),
                        heightSizedBox(30.0),
                        posterFlyerHead(
                          context,
                          customOptionsData[1]['image'],
                          customOptionsData[1]['name'].toUpperCase(),
                          () {
                            Navigator.pushNamed(context, '/poster', arguments: {
                              "printType":
                                  languageType == 'arabic' ? 'فلاير' : "Flyer",
                              'order_type': '1',
                              'order_type_no': '2',
                              "imageName": 'assets/images/flyerimg.png'
                            });
                          },
                        ),
                        heightSizedBox(30.0),
                        bannersRollUpHead(
                          context,
                          customOptionsData[2]['image'],
                          customOptionsData[2]['name'].toUpperCase(),
                          () {
                            Navigator.pushNamed(context, '/poster', arguments: {
                              "printType": languageType == 'arabic'
                                  ? 'رول أب'
                                  : "Rollup",
                              'order_type': '1',
                              'order_type_no': '3',
                              "imageName": 'assets/images/rollUp.png'
                            });
                          },
                        ),
                        heightSizedBox(30.0),
                      ],
                    ),
                  ),
          ),
          progressHUD,
        ],
      ),
    );
  }
}
