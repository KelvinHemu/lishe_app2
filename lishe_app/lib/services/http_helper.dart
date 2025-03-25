import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> makePostRequest(String url, Map<String, dynamic> body, [Map<String, String>? headers]) async {
  return await http.post(
    Uri.parse(url),
    headers: headers ?? {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );
}

Future<http.Response> makeGetRequest(String url, [Map<String, String>? headers]) async {
  return await http.get(Uri.parse(url), headers: headers ?? {'Content-Type': 'application/json'});
}

Future<http.Response> makePutRequest(String url, Map<String, dynamic> body, [Map<String, String>? headers]) async {
  return await http.put(
    Uri.parse(url),
    headers: headers ?? {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );
}
