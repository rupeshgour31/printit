import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';
import 'dart:convert';

class WSSaveCompleteOrderWithNewAddress extends APIRequest {
  String printryId;
  String vendorCharge;
  String pickupDelivery;
  String orderId;
  String userId;
  String address;
  String label;

  WSSaveCompleteOrderWithNewAddress({
    endPoint,
    this.printryId,
    this.vendorCharge,
    this.pickupDelivery,
    this.orderId,
    this.userId,
    this.address,
    this.label,
  }) : super(endPoint + "complete_order") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["printry_id"] = this.printryId;
    params["vendor_charge"] = this.vendorCharge;
    params["pickup_delivery"] = this.pickupDelivery;
    params["order_id"] = this.orderId;
    params["user_id"] = this.userId;
    params["label"] = this.label;
    params["address"] = this.address;
    params["latitude"] = '989898999';
    params["longitude"] = '252525222';

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
