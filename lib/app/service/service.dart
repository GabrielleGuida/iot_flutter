import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Service {

  String url = 'http://ec2-18-117-80-34.us-east-2.compute.amazonaws.com:8080/api/send';

  Future<bool> send(String message) async {

    debugPrint(message);

    Dio httpClient = Dio();

    Response response = await httpClient.post(url, data: {'value': message});

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
        debugPrint("Send with success");
      return true;
    } else {
      debugPrint("Send with error");
      return false;
    }

  }

}