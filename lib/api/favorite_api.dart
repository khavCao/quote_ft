// ignore_for_file: library_prefixes, non_constant_identifier_names
import 'package:http/http.dart' as http;


class FavoriteApi {
    static const baseURL = "127.0.0.1:8081";
  Future<http.Response> toggleFav({required String route,required int id ,required String token}) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8081/api/$route/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }


  Future<http.Response> FetchAll({required String route, required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8081/api/$route'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );
      // Check if the response is JSON
      if (response.headers['content-type']?.contains('application/json') == true) {
        return response;
      } else {
        throw FormatException('Unexpected content type: ${response.headers['content-type']}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      rethrow;
    }
  }

}