import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';
import 'dart:convert';

class WSGetAcceptProposalsListRequest extends APIRequest {
  String orderId;

  WSGetAcceptProposalsListRequest({
    endPoint,
    this.orderId,
  }) : super(endPoint + "translation_proposals") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["order_id"] = this.orderId;
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
