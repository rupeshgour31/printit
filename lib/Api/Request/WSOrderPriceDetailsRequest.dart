import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';

class WSOrderPriceDetailsRequest extends APIRequest {
  String email;
  String password;

  WSOrderPriceDetailsRequest({endPoint, this.email='', this.password=''})
      : super(endPoint + "order_price_detail") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["order_type"] = "1";
    params["coupon_code"] = "1";
    params["printery_price"] = "1";
    params["order_id"] = "1";
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

        this.response.addEntries(responseData.entries);
        retVal = "";
      } catch (e) {
        retVal = e.toString();
      }
    }
    return retVal;
  }
}
