import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';

class WSGetNotesOrderSaveRequest extends APIRequest {
  String projectName;
  String notesId;
  String totalPages;
  String serviceType;
  String userId;
  String copyNumber;
  String color;

  WSGetNotesOrderSaveRequest({
    endPoint,
    this.projectName,
    this.notesId,
    this.totalPages,
    this.serviceType,
    this.userId,
    this.copyNumber,
    this.color,
  }) : super(endPoint + "save_notes_order") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["project_name"] = this.projectName;
    params["note_id"] = this.notesId;
    params["total_pages"] = this.totalPages;
    params["order_type"] = this.serviceType;
    params["user_id"] = this.userId;
    params["copy_number"] = this.copyNumber;
    params["color"] = this.color;
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
