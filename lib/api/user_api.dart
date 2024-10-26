// ignore_for_file: library_prefixes, non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;


class UserApi {
  Future<http.Response> Register({required String route, required Map<String, String> data}) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8081/api/$route'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return response;
  }
}