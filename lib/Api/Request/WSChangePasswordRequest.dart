import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';
import 'dart:convert';

class WSChangePasswordRequest extends APIRequest {
  String? userId;
  String? oldPassword;
  String? newPassword;

  WSChangePasswordRequest({
    endPoint,
    this.userId,
    this.oldPassword,
    this.newPassword,
  }) : super(endPoint + "change_password") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["user_id"] = this.userId!;
    params["old_password"] = this.oldPassword!;
    params["password"] = this.newPassword!;
    params["cpassword"] = this.newPassword!;
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
