import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';
import 'dart:convert';

class WSSaveTranslationOrderRequest extends APIRequest {
  String user_id;
  String project_name;
  String trans_type;
  String lang_from;
  String lang_to;
  String trans_doc;

  WSSaveTranslationOrderRequest({
    endPoint,
    this.user_id,
    this.project_name,
    this.trans_type,
    this.lang_from,
    this.lang_to,
    this.trans_doc,
  }) : super(endPoint + "save_translation_order") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["user_id"] = this.user_id;
    params["project_name"] = this.project_name;
    params["trans_type"] = this.trans_type;
    params["lang_from"] = this.lang_from;
    params["lang_to"] = this.lang_to;
    params["trans_doc"] = this.trans_doc;
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
