import 'dart:io';

import 'package:http/http.dart' as http;

abstract class BaseApiService {
  Future<dynamic> getRequest({required String url});
  Future<dynamic> postRequest(
      {required String url, required Map<String, dynamic> jsonBody});
  Future<dynamic> postRequestAuth(
      {required String url, required Map<String, dynamic> jsonBody});
  Future<dynamic> postlogout({
    required String url,
  });

  Future<dynamic> multipart(
      {required String url,
      required Map<String, dynamic> jsonBody,
      File? file});
  Future<dynamic> multipart2({
    required String url,
    required Map<String, dynamic> jsonBody,
    required String? attributeName,
    required List<File>? files,
  });

  Future<http.Response> getRequestAuth({
    required String url,
  });
}
