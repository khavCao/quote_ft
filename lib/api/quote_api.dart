import 'dart:convert';
import 'package:quote/models/quote_model.dart';
import 'package:http/http.dart' as http;

class QuoteApi {
  static const baseURL = "127.0.0.1:8081"; // Use your machine's IP address if necessary

  static Future<List<QuoteModel?>> fetchAll(String endpoint, String token) async {
    var url = Uri.http(baseURL, '/api/$endpoint'); // Use Uri.http for HTTP requests

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        final result = data.map((e) {
          return QuoteModel(
            text: e['text'],
            id: e['id'],
            credit_to: e['credit_to'],
          );
        }).toList();
        return result;
      } else if (data is Map<String, dynamic> && data.containsKey('quotes')) {
        final quotes = data['quotes'] as List;
        final result = quotes.map((e) {
          return QuoteModel(
            text: e['text'],
            id: e['id'],
            credit_to: e['credit_to'],
          );
        }).toList();
        return result;
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('API error');
    }
  }
}