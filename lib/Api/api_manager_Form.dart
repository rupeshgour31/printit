import 'dart:convert';

import 'request_manager.dart';
import 'package:http/http.dart' as http;

class APIManagerForm {
  static final endpoint = 'http://tenspark.com/printit/api/';

  static Future<APIRequest> performRequest(APIRequest request,
      {bool showLog = false}) async {
    try {
      request.response.clear();

      String url = request.endPoint;
      Map<String, Object> params = request.getParams();
      Map<String, Object> headers = request.getHeaders();

      if (showLog) {
        print("URL: $url");
        print("Perform request with data: ${params}");
        print("Perform request with header: ${jsonEncode(headers)}");
      }

      final http.Response response =
          await http.post(url, headers: headers, body: params);

      print("statusCode: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        request.parseResponse(response, showLog);
      } else if (response.statusCode == 204) {
        request.parseResponse(response, showLog);
      } else if (response.body.isNotEmpty) {
        String errorMessage = "";
        Map<String, Object> errors = jsonDecode(response.body);
        if (errors.containsKey('errors')) {
          List<dynamic> errorList = errors['errors'];
          for (int i = 0; i < errorList.length; i++) {
            Map<String, Object> error = errorList[i];
            if (error.containsKey("code") && error.containsKey("message")) {
              String code = error["code"];
              String message = error["message"];

              if (errorMessage.isEmpty) {
                errorMessage = "Error ($code) $message";
              } else {
                errorMessage = "$errorMessage, Error ($code) $message";
              }
            }
          }
          if (errorMessage.isNotEmpty) {
            print("Error 2: $errorMessage");
          } else {
            print("Error 3: ${response.body}");
          }
        }
      } else {
        print("Error 4: ${response.body}");
      }
    } catch (e) {
      print(e.toString());
    }
    return request;
  }
}
