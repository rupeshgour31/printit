import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';

class WSLoginRequest extends APIRequest {
  String email;
  String password;
  String deviceToken;

  WSLoginRequest({
    endPoint,
    this.email='',
    this.password='',
    this.deviceToken='',
  }) : super(endPoint + "login") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["email"] = this.email;
    params["password"] = this.password;
    params["device_token"] = this.deviceToken;
    // params["login_type"] = "1";
    // params["device_type"] = "Android";
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
