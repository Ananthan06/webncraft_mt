
/// Webservice class , this module api fetch and error handling.

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webncraft_mt/webservices/employee_response.dart';

class WebServices {
  static const String url =
      "http://www.mocky.io/v2/5d565297300000680030a986";

  ///Function to call api request and get data and handle error.
  Future<dynamic> getResponsePostData(context) async {
    try {
      final response = await http.get(Uri.parse(url));
      var statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || statusCode == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error in webservice"),
        ));
      } else {
        return EmployeeApiResponse.fromJson(json.decode(response.body));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
