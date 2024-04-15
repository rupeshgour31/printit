import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:printit_app/Api/request_manager.dart';

class WSNotesListAndCategRequest extends APIRequest {
  WSNotesListAndCategRequest({
    endPoint,
  }) : super(endPoint + 'notes_data') {}

  @override
  Map<String, String> getHeaders() {
    Map<String, String> headers = Map<String, String>();
    headers['Content-Type'] = 'application/json';
    return headers;
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
