import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';

class WSGetPrintOptionsRequest extends APIRequest {
  String order_type;
  String print_type;

  WSGetPrintOptionsRequest({
    endPoint,
    this.order_type='',
    this.print_type='',
  }) : super(endPoint + "dropdown_options") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["order_type"] = order_type;
    params["print_type"] = print_type;
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
