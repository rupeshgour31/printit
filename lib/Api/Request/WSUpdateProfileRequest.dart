import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';
import 'dart:convert';

class WSUpdateProfileRequest extends APIRequest {
  String userId;
  String fName;
  String lName;
  String gender;
  String mobile;

  WSUpdateProfileRequest({
    endPoint,
    this.userId,
    this.fName,
    this.lName,
    this.gender,
    this.mobile,
  }) : super(endPoint + "update_profile") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["user_id"] = this.userId;
    params["gender"] = this.gender;
    params["f_name"] = this.fName;
    params["l_name"] = this.lName;
    params["mobile"] = this.mobile;
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
