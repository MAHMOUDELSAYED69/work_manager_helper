import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

abstract class ApiService {
  Future<Map<String, dynamic>> fetchData();
}

class ApiServiceImpl implements ApiService {
  final String url;

  ApiServiceImpl({this.url = 'https://jsonplaceholder.typicode.com/posts/1'});

  @override
  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("Data fetched successfully");
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }
}
