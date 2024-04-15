import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';

class WSDeleteSavedItemsRequest extends APIRequest {
  var order_id;
  var user_id;

  WSDeleteSavedItemsRequest({
    endPoint,
    this.order_id,
    this.user_id,
  }) : super(endPoint + "delete_saved_orders") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["order_ids"] = this.order_id;
    params["user_id"] = this.user_id;
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
