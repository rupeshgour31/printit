import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';

class WSAddNewAddressRequest extends APIRequest {
  String user_id;
  String label;
  String address;
  String address_type;
  String block;
  String street;
  String building;
  String house;
  String mobile;
  String apartment_no;
  String floor;
  String avenue;
  String additional_directions;
  String landline;
  String office;
  String latitude;
  String longitude;


  WSAddNewAddressRequest({
    endPoint,
    this.user_id,
    this.label,
    this.address,
    this.address_type,
    this.block,
    this.street,
    this.building,
    this.house,
    this.mobile,
    this.floor,
    this.apartment_no,
    this.avenue,
    this.additional_directions,
    this.landline,
    this.office,
    this.latitude,
    this.longitude
  }) : super(endPoint + "add_address") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["user_id"] = this.user_id;
    params["label"] = this.label;
    params["address"] = this.address;
    params["address_type"] = this.address_type;
    params["block"] = this.block;
    params["street"] = this.street;
    params["building"] = this.building;
    params["house"] = this.house;
    params["mobile"] = this.mobile;
    params["apartment_no"] = this.apartment_no;
    params["floor"] = this.floor;
    params["avenue"] = this.avenue;
    params["additional_directions"] = this.additional_directions;
    params["landline"] = this.landline;
    params["office"] = this.office;
    params['latitude'] = this.latitude;
    params['longitude'] = this.longitude;
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
