import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';

class WSUpdateOrdersRequest extends APIRequest {
  String orderId;
  String printryId;
  String vendorCharge;
  String pickupDelivery;
  String couponCode;
  String addId;

  WSUpdateOrdersRequest({
    endPoint,
    this.orderId='',
    this.printryId='',
    this.vendorCharge='',
    this.pickupDelivery='',
    this.couponCode='',
    this.addId='',
  }) : super(endPoint + "update_order") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["order_id"] = this.orderId;
    if (printryId != null) {
      params["printry_id"] = this.printryId;
    }
    if (vendorCharge != null) {
      params["vendor_charge"] = this.vendorCharge;
    }
    if (pickupDelivery != null) {
      params["pickup_delivery"] = this.pickupDelivery;
    }
    if (couponCode != null) {
      params["coupon_code"] = this.couponCode;
    }
    if (addId != null && addId != '') {
      params["address_id"] = this.addId;
    }
    return params;
  }

  // Map<String, String> getHeaders() {
  //   Map<String, String> headers = Map<String, String>();
  //   headers['Content-Type'] =
  //       'multipart/form-data; boundary=<calculated when request is sent>';
  //   headers['Content-Length'] = '<calculated when request is sent>';
  //   headers['Host'] = '<calculated when request is sent>';
  //   headers['User-Agent'] = 'PostmanRuntime/7.26.10';
  //   headers['Accept'] = '*/*';
  //   headers['Accept-Encoding'] = 'gzip, deflate, br';
  //   // headers['Accept'] = '*/*';
  //   return headers;
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
