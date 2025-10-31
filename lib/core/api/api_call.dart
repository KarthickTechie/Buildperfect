import 'dart:convert';
import 'package:dio/dio.dart';

class ApiCall {
  Dio dio;
  String url;
  String method;
  Map<String, dynamic> request;
  Map<String, dynamic>? headers;
  ApiCall({
    required this.dio,
    required this.url,
    required this.method,
    required this.request,
    this.headers,
  });

  dynamic callApi() async {
    Response response;
    if (method == 'GET' || method == 'get') {
      response = await dio.get(
        url,
        data: jsonEncode(request),
        options: Options(headers: headers),
      );
      print('GET Dio response $response');
    } else if (method == 'POST' || method == 'post') {
      response = await dio.post(
        url,
        data: jsonEncode(request),
        options: Options(headers: headers),
      );
      print('POST Dio response $response');
    } else if (method == 'DELETE' || method == 'delete') {
      response = await dio.delete(
        url,
        data: jsonEncode(request),
        options: Options(headers: headers),
      );
      print('DELETE Dio response $response');
    } else {
      response = await dio.put(
        url,
        data: jsonEncode(request),
        options: Options(headers: headers),
      );
      print('PUT Dio response $response');
    }
    return response;
  }
}
