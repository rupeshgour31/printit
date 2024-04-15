import 'package:flutter/material.dart';
import 'package:printit_app/Api/Request/WSSignUpRequest.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/LogIn/login.dart';

class SignUpModel extends ChangeNotifier {
  bool _obscureText = true;
  bool get obscureText => _obscureText;
  var latitude = '29.31166';
  var longitude = '47.481766';
  var areaName = '';

  setAreaName(areaString) {
    areaName = areaString;
    notifyListeners();
  }

  TextEditingController signUpEmail = TextEditingController();
  TextEditingController signUpPassword = TextEditingController();
  TextEditingController signUpMobile = TextEditingController();
  TextEditingController signUpFirstName = TextEditingController();
  TextEditingController signUpLastName = TextEditingController();
  TextEditingController signUpAddress = TextEditingController();
  toggle() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  signUpUser(context) async {
    progressHUD.state.show();
    print("latitude $latitude");
    print("latitude $longitude");

    var otpRequest = WSSignUpRequest(
      endPoint: APIManagerForm.endpoint,
      email: signUpEmail.text,
      password: signUpPassword.text,
      f_name: signUpFirstName.text,
      l_name: signUpLastName.text,
      mobile: signUpMobile.text,
      address: areaName,
      latitude: latitude,
      longitude: longitude,
    );
    await APIManagerForm.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString(
        //   'login_user_id',
        //   json.encode(
        //     dataResponse['user_id'],
        //   ),
        // );
        // prefs?.setBool("isLoggedIn", true);
        progressHUD.state.dismiss();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
          (Route<dynamic> route) => false,
        );
        signUpEmail.clear();
        signUpPassword.clear();
        signUpMobile.clear();
        signUpMobile.clear();
        signUpFirstName.clear();
        signUpLastName.clear();
        signUpAddress.clear();
        areaName = "";
        notifyListeners();
      } else {
        var messages = dataResponse['msg'];
        progressHUD.state.dismiss();
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
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(right: 50.0),
                      height: 50,
                      child: Text(
                        messages,
                        // textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Nunito',
                        ),
                        maxLines: 2,
                      ),
                    ),
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

  void initTask(context) async {
    _obscureText = true;
    notifyListeners();
    new Future.delayed(
      Duration.zero,
      () async {
        notifyListeners();
      },
    );
  }
}
