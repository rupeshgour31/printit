import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';

class WSSignUpRequest extends APIRequest {
  String f_name;
  String l_name;
  String email;
  String password;
  String mobile;
  String address;
  String latitude;
  String longitude;

  WSSignUpRequest({
    endPoint,
    this.f_name='',
    this.l_name='',
    this.email='',
    this.password='',
    this.mobile='',
    this.address='',
    this.latitude='',
    this.longitude='',
  }) : super(endPoint + "user_resgister") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["f_name"] = this.f_name;
    params["email"] = this.email;
    params["password"] = this.password;
    params["l_name"] = this.l_name;
    params["mobile"] = this.mobile;
    params["address"] = this.address;
    params['user_lat'] = this.latitude;
    params['user_lng'] = this.longitude;
    return params;
  }

  @override
  String parseResponse(http.Response response, bool showLog) {
    super.parseResponse(response, showLog);

    String retVal = "Problem occured in parsing the response";
    if (response.statusCode == 200) {
      try {
        Map<String, Object> responseData = jsonDecode(response.body);

        if (responseData.containsKey("success")) {
          this.response.addEntries(responseData.entries);
          retVal = "";
        }
      } catch (e) {
        retVal = e.toString();
      }
    }
    return retVal;
  }
}
