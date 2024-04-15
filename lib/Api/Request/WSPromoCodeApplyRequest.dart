import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';
import 'dart:convert';

class WSSApplyPromoCodeRequest extends APIRequest {
  String couponCode;
  String orderId;
  String vendorCharge;
  String serviceType;
  String pickupDelivery;

  WSSApplyPromoCodeRequest({
    endPoint,
    this.couponCode,
    this.orderId,
    this.vendorCharge,
    this.serviceType,
    this.pickupDelivery,
  }) : super(endPoint + "apply_coupon") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["coupon_code"] = this.couponCode;
    params["order_id"] = this.orderId;
    params["vendor_charge"] = this.vendorCharge;
    params["service_type"] = this.serviceType;
    params["pickup_delivery"] = this.pickupDelivery;
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
