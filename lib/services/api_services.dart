import 'dart:convert';
import 'dart:developer';
import 'package:final_blog_project/services/status_code.dart';
import 'package:final_blog_project/services/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

import 'api_constants.dart';

// Class of the Api service , Define all the api functions Like GET, POST, PUT AND DELETE
class ApiServices {
  Future getApi({required String api, required Map<String, dynamic> body}) async {
    try {
      final response = await dio.Dio().get(api,
        data: body,
      );
      log(response.statusCode.toString());
      if (response.statusCode == ServerStatusCodes.success) {
        log(response.data.toString());
        var jsonData = response.data;
        return jsonData;
      }
    } catch (e) {
      log(e.toString());
    }
  }

//POST APi , Function to Send new Blog Data to the Database
  Future postApi({required String api, required Map<String, dynamic> body}) async {
    // final response = await http.post(
    //   Uri.parse(api),
    //   // body: data,
    // );

    final response_1 = await dio.Dio().post(
      api,
      data: body,
    );

    if (response_1.statusCode == ServerStatusCodes.addSuccess) {
      // var jsonData = jsonDecode(response.body);
      var jsonData = response_1.data;
      log('Status code: ${response_1.statusCode}');
      log('Response body: ${response_1.data}');

      return jsonData;
    } else {
      log('Failed to add task. Status code: ${response_1.statusCode}');
      log('Response body: ${response_1.data}');
    }
  }
}
