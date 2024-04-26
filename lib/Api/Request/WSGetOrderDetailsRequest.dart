import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';

class WSGetOrderDetailsRequest extends APIRequest {
  String orderID;

  WSGetOrderDetailsRequest({endPoint, this.orderID = ''})
      : super(endPoint + "order_price_detail") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["order_id"] = orderID;
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

        this.response.addEntries(responseData.entries);
        retVal = "";
      } catch (e) {
        retVal = e.toString();
      }
    }
    return retVal;
  }
}
