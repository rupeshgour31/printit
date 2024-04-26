import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';

class WSAddNewProductRequest extends APIRequest {
  String? orderId;
  String? productId;
  String? quantity;

  WSAddNewProductRequest({
    endPoint,
    this.orderId,
    this.productId,
    this.quantity,
  }) : super(endPoint + "add_product") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["order_id"] = this.orderId!;
    params["prod_id"] = this.productId!;
    params["qty"] = this.quantity!;
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
