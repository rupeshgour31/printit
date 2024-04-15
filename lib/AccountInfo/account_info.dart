import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:printit_app/AccountInfo/account_info_model.dart';
import 'package:printit_app/AccountInfo/account_info_widgets.dart';
import 'package:printit_app/Api/Request/WSGetAccountInfoRequest.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  var user_id;
  var get_print_type;
  var accountInfo;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getValuesSF();
      await getAccountInfo();
    });
    super.initState();
  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    if (status) {
      setState(
        () {
          user_id = json.decode(prefs.getString('login_user_id'));
          get_print_type = json.decode(prefs.getString('set_print_type'));
        },
      );
    }
  }

  @override
  getAccountInfo() async {
    progressHUD.state.show();
    var otpRequest = WSGetAccountInfoRequest(
      endPoint: APIManagerForm.endpoint,
      userId: user_id.toString(),
    );
    await APIManagerForm.performRequest(otpRequest, showLog: true);

    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == 'true') {
        print('jdf ${dataResponse['data']}');
        setState(() {
          accountInfo = dataResponse['data'];
        });
        progressHUD.state.dismiss();
      } else {
        progressHUD.state.dismiss();
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountInfoModel>(
      builder: (context, model, _) {
        return MediaQuery(
          data: mediaText(context),
          child: Scaffold(
            appBar: commonAppbar(
              'Account',
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
                Container(
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
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                          left: 25.0,
                          right: 25.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            userName(accountInfo, model),
                            heightSizedBox(5.0),
                            accInfoEmail(accountInfo),
                            accInfoFirstName(model, accountInfo),
                            // accInfoMiddleName(model),
                            accInfoLastName(model, accountInfo),
                            accInfoMobile(model, accountInfo),
                            heightSizedBox(15.0),
                            genderText(),
                            heightSizedBox(15.0),
                            genderField(model),
                            heightSizedBox(45.0)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                progressHUD,
              ],
            ),
            bottomNavigationBar:
                updateAccount(context, model, user_id, accountInfo),
          ),
        );
      },
    );
  }
}
