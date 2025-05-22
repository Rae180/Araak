import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/errors/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:start/core/utils/helpers/decode_response.dart';
import 'package:start/core/utils/services/shared_preferences.dart';

class NetworkApiServiceHttp implements BaseApiService {
  @override
  Future getRequest({required String url}) async {
    try {
      //    String? lan = PreferenceUtils.getString(
      //   'LANGUAGE',
      // );
      // String lan = '';
      //   String? token = '';
      //PreferenceUtils.getString('TOKEN');
      print('url $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json; charset=utf-8",
          'api': '1.0.0',
          'X-Requested-With': "XMLHttpRequest",
          //"Locale": lan,
          "Accept": "application/json",
          //  if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('status code ${response.statusCode}');
      print('the body : ${response.body}');
      final decodedResponse = DecodeResponse.decode(response);

      return decodedResponse;
    } on SocketException {
      throw ExceptionSocket();
    } on FormatException {
      throw ExceptionFormat();
    } on TimeoutException {
      throw ExceptionTimeout();
    } on HandshakeException {
      throw ExceptionHandshake();
    } on CustomException catch (e) {
      throw CustomException(message: e.message);
    } on Exception {
      throw ExceptionOther();
    }
  }

  Future getRequest2(
      {required String url, Map<String, String>? parameters}) async {
    try {
      final uri = Uri.parse(url);

      var request = http.Request('GET', uri);
      request.body = json.encode(parameters);
      request.headers.addAll({
        "Content-Type": "application/json; charset=utf-8",
        'api': '1.0.0',
        'X-Requested-With': "XMLHttpRequest",
        "Accept": "application/json",
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return json.decode(responseBody);
      } else {
        throw Exception('Failed to load data: ${response.reasonPhrase}');
      }
    } on SocketException {
      throw ExceptionSocket();
    } on FormatException {
      throw ExceptionFormat();
    } on TimeoutException {
      throw ExceptionTimeout();
    } on HandshakeException {
      throw ExceptionHandshake();
    } on CustomException catch (e) {
      throw CustomException(message: e.message);
    } on Exception {
      throw ExceptionOther();
    }
  }

  @override
  Future<http.Response> getRequestAuth({required String url}) async {
    try {
      //    String? lan = PreferenceUtils.getString(
      //   'LANGUAGE',
      // );
      // String lan = '';
      String? token;
      token = PreferenceUtils.getString('token');
      // token =
      //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNzZkMjdhZmNmNzVlN2E4MjU3YjBiZmE0ZTgxYjg0OTI4MGYxZDE4MjJlMGM5NThhNDIwNTAxZmUwMzVjZGVlMTdiMDc1YWI3MGJiNWMyZjEiLCJpYXQiOjE3MTkxNzU4MTcsIm5iZiI6MTcxOTE3NTgxNywiZXhwIjoxNzUwNzExODE3LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.ff4zNFWAY071_pbttJ4evO7NDJuf6LkvDIdqNk8Kx6-WeIf4nhJy-JPQLrUZaZZYWs94wlP-9Go5qdnE-DgUXsSKq2JTAMax2qF5ZeDQ_ju917BUpcbi25CtElTu6SvZk5ryCPBUpBcVsCq_rUbZUCwDVUWCaHo1VjA1ZfM-q6fLOxyngfnTcwHJJQeYLjSt2lvplbdh0r6rIlrz3itw0Db1PybzReZj123lvP5eBowIpEHmprejppP6sW82j3ExTIgPDh7SkjJqxs35kIVQVEqIvUK_O2_lQ5_-DuQeE08ue-JR7Bjg4s1HJJwJPdwJTNTgax_5fThRno8WXBRC2HnFbU4FQ72wEZASYy0pg8pF5wE0VI6odMLd2Qc0yECvPR1EzUBOhQJqU_7anI-o-A0ffoybypP77BoM4kz7aUzV6rxviroV_9XdPIqpvE-eLyh5tu1svKITng-cR5OIFJM-IkNBg2M0dMtwaqCjWnZuRSM0nJBva5DxN-qZkBD909UZjivibN0DDJPKE-PYKWTMYn0HWZT-8d9GNnyYTUz711PK1daC9_y-m7kw5YQ8a2H4oyJGbfmZ46l07HakPDXEjwA1psvvv-X4IQ5k501lLhfLX1Rk_JRO5-AqT6sTzXSNyLzVqMHklltyT7QDpQyliHAKtjVLEmflgxJbOfc';
      print('url $url');
      print('the token here is :$token');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json; charset=utf-8",
          'api': '1.0.0',
          'X-Requested-With': "XMLHttpRequest",
          //"Locale": lan,
          "Accept": "application/json",
          if (token != null) 'Authorization': 'Bearer $token',
//                'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNTJmOTM5ZGNkMzY3NjBlYjkyYjBkZTAyMDRhZjUzOWFlNzgxODIzNDJiMGIwMmUyNWIwYmMyYzdmYTRkZDlkN2JjOWQ1NDBiYjk4NDUwZWYiLCJpYXQiOjE3MTk2MTA3NjYsIm5iZiI6MTcxOTYxMDc2NiwiZXhwIjoxNzUxMTQ2NzY2LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.UkF5eNtJ7Wo_yOQiJnKII9jYaAu7DFRpT07C-zBgzfPvanXNX19MMlZL_LdeVJ6ZgnNdZwtsg7EMitB8oD_Lr9kyVvBW44WTuNtB7lYlZScsIgx6nq2ek9-KB2Jxygf-bYDO8ZqtughFXY818phbbgCMxUKRQvegZWDarNXAl2TFkLTNmy-lMmtKNqFn31XYr3hmCXkDUwgEX-zH-nzhyYSQpNZ0yUjqr3MgLE6XH_XKvs03FcEL--WEs8yZ5NKU6SLZtfcL61FVMZh3lITGYwBU4Uxp1QdCDivj0wj0VGkiQL1eQx7luzIm0CwHSXJtg_WpVtbqWaztAHSmnpROrE4l3iwO3SopG3ncSPKKlXZAsNmw9jjokjV6yFQyCcvHoDJHra6QrjDoOhS0n1f-0sSrgwNTS-seSIFdVBV9PO0zJ-ydA5ati0JOr_4ppiTrn2-yZUU9KY9TDjd_Q6HyXo9wnaTDcpe6vBVy23rm8gqqLaost6umI8TX-qWkAcJoJ0fYNthb-_UaydO5P8Se58pE9Kjim1gz_zR4YfGNckCDIHZS-LNt_0LCCEyGFJiKGGasJTq9fZT-xbsdzRxmvc98RDtCvg2bWFPgjt2sAMaUrzRMc7fKpiT6k7UhEjeKcEYKxqOij-Xt00GowRMR8BS6V8zp9Nd4qkMFKnZErfM',
        },
      );

      print('status code ${response.statusCode}');
      print('the body : ${response.body}');
      //  final decodedResponse = DecodeResponse.decode(response) as Map<String,dynamic>;
      //   print('decoded response: $decodedResponse');

      return response;
    } on SocketException {
      throw ExceptionSocket();
    } on FormatException {
      throw ExceptionFormat();
    } on TimeoutException {
      throw ExceptionTimeout();
    } on HandshakeException {
      throw ExceptionHandshake();
    } on CustomException catch (e) {
      throw CustomException(message: e.message);
    } on Exception {
      throw ExceptionOther();
    }
  }

  @override
  Future multipart(
      {required String url,
      required Map<String, dynamic> jsonBody,
      File? file}) async {
    try {
      String? token;
      token = PreferenceUtils.getString('token');
      print('the token here is :$token');
      // String? token =
      //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNTQ5YjU4NzNjYmZmNGRjN2MwMDdiMTFiNzQzMWJiOTU4NjFhMmYwNmE5MzE4MWEwOTcyYTFiNDk2ZjgxMDIzODU2NTdiNTU3NDNlMjc5YTYiLCJpYXQiOjE3MTc3MDY3NjQsIm5iZiI6MTcxNzcwNjc2NCwiZXhwIjoxNzQ5MjQyNzY0LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.Ox_YAey_WOPmuwYW6v8yfnqonMUgdrfwR-3cuuQ09r_uR8XkO-jvqcv7_SawHx-b9jg2mqQFolgcG6_0v0VmNYTHj219C84C9pyo5euRaPVQ7GONcO3-4bCFM5a1dBULSvq2m2rVxkleIeRiKZj_gI7F7fT3ymyytPBiYjIbxcFbACeR0GRmHVQx4M4-DQDRDnlS8fd27q-FatxkDSxYoUPC_7XQZb7TiN8aohfazUEYxINytUycM0NZGsvsYCk2_sY-1_BtwzcPPRht5vS2iF2x0tLkvWJYMI7U8Lrpk2z5Qp-JxYY0F5LU0pV6ZOgfZ4us9ksGsnU_rWDroLNfBd6T6CSS1qktx0e4YTmyWIqoLvYNYOKOqyJWyG3zBwqeXQqZXHOZ0hyy4tWCoxYs5OvLklxFgoHuQY-T_Na2D7ckxufAjopO_BMl9kdD3-bTsQGojzdPs0hOQQm9_-aTPTZTo_VBHlkM0nEoHglI3VFNWj1_tNFSGCuKWRutNgB3qNzBtuuEp8O0jaapZ_GbYtaK5aNnwCk0VbHBao3nB7wmSNPGxQ0suXXW9wIFhJKkeN9Zft_Efu54GNGwQjiJoBe8UxSn3gBxxUL-E478y7fzffsmMxEsMr1-MpRTJdKH1iPDlwNxAHxbBdbJ0YveuQ1Upd7iEuFyWVDAwGV6lWQ';

      //PreferenceUtils.getString('TOKEN');
      print('url $url');
      print('the posted body ${jsonBody.toString()}');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request = jsonToFormData(request, jsonBody);

      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'path',
          file.path,
        ));
      }
      print('request ${request.fields.toString()}');

      request.headers['X-Requested-With'] = "XMLHttpRequest";
      request.headers['content-type'] = "application/json; charset=utf-8";

      request.headers['Authorization'] = "Bearer $token";
      final response = await request.send();
      final decodedResponse =
          DecodeResponse.decodeMultiplePartResponse(response);
      return decodedResponse;
    } on SocketException {
      throw ExceptionSocket();
    } on FormatException {
      throw ExceptionFormat();
    } on TimeoutException {
      throw ExceptionTimeout();
    } on HandshakeException {
      throw ExceptionHandshake();
    } on CustomException catch (e) {
      throw CustomException(message: e.message);
    } on Exception {
      throw ExceptionOther();
    }
  }

  @override
  Future multipart2(
      {required String url,
      required Map<String, dynamic> jsonBody,
      required String? attributeName,
      required List<File>? files}) async {
    try {
      String? token = PreferenceUtils.getString('token');
      print('url $url');
      print('the posted body ${jsonBody.toString()}');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request = jsonToFormData(request, jsonBody);
      print('request ${request.fields.toString()}');
      if (files != null) {
        for (var element in files) {
          print('file: ${element.path}');
          request.files.add(await http.MultipartFile.fromPath(
            attributeName!,
            element.path,
          ));
        }
      }

      request.headers['X-Requested-With'] = "XMLHttpRequest";
      request.headers['content-type'] = "application/json; charset=utf-8";
      request.headers['Authorization'] = token!;
      final response = await request.send();
      final decodedResponse =
          DecodeResponse.decodeMultiplePartResponse(response);
      return decodedResponse;
    } on SocketException {
      throw ExceptionSocket();
    } on FormatException {
      throw ExceptionFormat();
    } on TimeoutException {
      throw ExceptionTimeout();
    } on HandshakeException {
      throw ExceptionHandshake();
    } on CustomException catch (e) {
      throw CustomException(message: e.message);
    } on Exception {
      throw ExceptionOther();
    }
  }

  Future delete({
    required String url,
  }) async {
    try {
      //    String? lan = PreferenceUtils.getString(
      //   'LANGUAGE',
      // );
      // lan ??= 'en';
      String? token = PreferenceUtils.getString('token');
      print('url $url');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "content-type": "application/json; charset=utf-8",
          'api': '1.0.0',
          'X-Requested-With': "XMLHttpRequest",
          //  "Locale": lan,
          "Accept": "application/json",
          if (token != null) 'Authorization': token,
        },
      );

      print('status code ${response.statusCode}');
      print('the body is sisiisisisis : ${response.body}');
      final decodedResponse = DecodeResponse.decode(response);

      return decodedResponse;
    } on SocketException {
      throw ExceptionSocket();
    } on FormatException {
      throw ExceptionFormat();
    } on TimeoutException {
      throw ExceptionTimeout();
    } on HandshakeException {
      throw ExceptionHandshake();
    } on CustomException catch (e) {
      throw CustomException(message: e.message);
    } on Exception {
      throw ExceptionOther();
    }
  }

  @override
  Future postRequest(
      {required String url, required Map<String, dynamic> jsonBody}) async {
    try {
      //    String? lan = PreferenceUtils.getString(
      //   'LANGUAGE',
      // );
      // lan ??= 'en';
      // String? token = PreferenceUtils.getString('TOKEN');
      print('url $url');
      print('the posted body ${jsonBody.toString()}');
      final response = await http.post(Uri.parse(url),
          headers: {
            "content-type": "application/json; charset=utf-8",
            'api': '1.0.0',
            'X-Requested-With': "XMLHttpRequest",
            //  "Locale": lan,
            "Accept": "application/json",
            //  if (token != null) 'Authorization': 'Bearer $token',
          },
          body: json.encode(jsonBody));

      print('status code ${response.statusCode}');
      print('the body is sisiisisisis : ${response.body}');
      final decodedResponse = DecodeResponse.decode(response);

      return decodedResponse;
    } on SocketException {
      throw ExceptionSocket();
    } on FormatException {
      throw ExceptionFormat();
    } on TimeoutException {
      throw ExceptionTimeout();
    } on HandshakeException {
      throw ExceptionHandshake();
    } on CustomException catch (e) {
      throw CustomException(message: e.message);
    } on Exception {
      throw ExceptionOther();
    }
  }

  @override
  Future postRequestAuth(
      {required String url, required Map<String, dynamic> jsonBody}) async {
    try {
      //    String? lan = PreferenceUtils.getString(
      //   'LANGUAGE',
      // );
      // lan ??= 'en';
      String? token = PreferenceUtils.getString('token');
      print('url $url');
      print(' the token is : $token');

      print('the posted body ${jsonBody.toString()}');
      final response = await http.post(Uri.parse(url),
          headers: {
            "content-type": "application/json; charset=utf-8",
            'api': '1.0.0',
            'X-Requested-With': "XMLHttpRequest",
            //  "Locale": lan,
            "Accept": "application/json",
            if (token != null) 'Authorization': 'Bearer $token',
            //   'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNTJmOTM5ZGNkMzY3NjBlYjkyYjBkZTAyMDRhZjUzOWFlNzgxODIzNDJiMGIwMmUyNWIwYmMyYzdmYTRkZDlkN2JjOWQ1NDBiYjk4NDUwZWYiLCJpYXQiOjE3MTk2MTA3NjYsIm5iZiI6MTcxOTYxMDc2NiwiZXhwIjoxNzUxMTQ2NzY2LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.UkF5eNtJ7Wo_yOQiJnKII9jYaAu7DFRpT07C-zBgzfPvanXNX19MMlZL_LdeVJ6ZgnNdZwtsg7EMitB8oD_Lr9kyVvBW44WTuNtB7lYlZScsIgx6nq2ek9-KB2Jxygf-bYDO8ZqtughFXY818phbbgCMxUKRQvegZWDarNXAl2TFkLTNmy-lMmtKNqFn31XYr3hmCXkDUwgEX-zH-nzhyYSQpNZ0yUjqr3MgLE6XH_XKvs03FcEL--WEs8yZ5NKU6SLZtfcL61FVMZh3lITGYwBU4Uxp1QdCDivj0wj0VGkiQL1eQx7luzIm0CwHSXJtg_WpVtbqWaztAHSmnpROrE4l3iwO3SopG3ncSPKKlXZAsNmw9jjokjV6yFQyCcvHoDJHra6QrjDoOhS0n1f-0sSrgwNTS-seSIFdVBV9PO0zJ-ydA5ati0JOr_4ppiTrn2-yZUU9KY9TDjd_Q6HyXo9wnaTDcpe6vBVy23rm8gqqLaost6umI8TX-qWkAcJoJ0fYNthb-_UaydO5P8Se58pE9Kjim1gz_zR4YfGNckCDIHZS-LNt_0LCCEyGFJiKGGasJTq9fZT-xbsdzRxmvc98RDtCvg2bWFPgjt2sAMaUrzRMc7fKpiT6k7UhEjeKcEYKxqOij-Xt00GowRMR8BS6V8zp9Nd4qkMFKnZErfM',
          },
          body: json.encode(jsonBody));

      print('status code ${response.statusCode}');
      print('the body is sisiisisisis : ${response.body}');
     // final decodedResponse = DecodeResponse.decode(response);

      return response;
    } on SocketException {
      throw ExceptionSocket();
    } on FormatException {
      throw ExceptionFormat();
    } on TimeoutException {
      throw ExceptionTimeout();
    } on HandshakeException {
      throw ExceptionHandshake();
    } on CustomException catch (e) {
      throw CustomException(message: e.message);
    } on Exception {
      throw ExceptionOther();
    }
  }

  @override
  Future postlogout({required String url}) {
    // TODO: implement postlogout
    throw UnimplementedError();
  }
}

jsonToFormData(http.MultipartRequest request, Map<String, dynamic> data) {
  for (var key in data.keys) {
    request.fields[key] = data[key].toString();
  }
  return request;
}
