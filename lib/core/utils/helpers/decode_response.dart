import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../errors/exceptions.dart';

class DecodeResponse {
  static dynamic decode(http.Response response) {
    try {
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        print('decoding....');
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['error'];
        throw CustomException(message: errorMessage);
      }
    } on FormatException {
      print('exception decoding');
      throw ExceptionFormat();
    }
  }

  static dynamic decodeMultiplePartResponse(
      http.StreamedResponse response) async {
    try {
      String responseString = '';
      final responseData = await response.stream.toBytes();
      responseString = String.fromCharCodes(responseData);

      print('status code ${response.statusCode}');
      print('responseString $responseString');
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return json.decode(responseString) as Map<String, dynamic>;
      } else {
        final errorData = json.decode(responseString);
        String errorMessage = errorData['error'];
        throw CustomException(message: errorMessage);
      }
    } on FormatException {
      print('exception decoding');
      throw ExceptionFormat();
    }
  }
}
