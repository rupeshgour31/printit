import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';
import 'dart:convert';

class WSSaveQuickPrintOrderRequest extends APIRequest {
  String user_id;
  String project_name;
  String paper_type;
  String paper_size;
  String copy_number;
  String order_type;
  String color;
  String binding;
  String image;

  WSSaveQuickPrintOrderRequest({
    endPoint,
    this.user_id='',
    this.project_name='',
    this.paper_type='',
    this.paper_size='',
    this.copy_number='',
    this.order_type='',
    this.color='',
    this.binding='',
    this.image='',
  }) : super(endPoint + "save_quick_print_order") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["user_id"] = this.user_id;
    params["project_name"] = this.project_name;
    params["paper_type"] = this.paper_type;
    params["paper_size"] = this.paper_size;
    params["copy_number"] = this.copy_number;
    params["order_type"] = this.order_type;
    params["color"] = this.color;
    params["binding"] = this.binding;
    params["image"] = this.image;
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
