import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';

class WSGetProductListRequest extends APIRequest {
  WSGetProductListRequest({
    endPoint,
  }) : super(endPoint + "product_list") {}

  @override
  // Map<String, Object> getParams() {
  //   Map<String, Object> params = Map<String, Object>();
  //   params["user_id"] = this.userId;
  //   return params;
  // }

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
