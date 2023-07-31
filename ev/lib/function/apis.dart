import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

Future login(String id, String password) async {
  Uri apiUrl = Uri.parse('http://192.168.1.65:8080/login');

  Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  Map<String, String> body = {
    'id': id,
    'password': password,
  };
  http.Response response =
      await http.post(apiUrl, headers: headers, body: body);
  final data = response.body;
  print(data);
  return data;
}

Future registerUser(String id, String password, String name) async {
  List<int> bytes = utf8.encode(password);
  Digest digest = sha256.convert(bytes);
  String hashPassword = digest.toString();

  Uri apiUrl = Uri.parse('http://192.168.0.111:8080/register');
  Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  Map<String, String> body = {
    'email': id,
    'password': hashPassword,
    'name': name
  };
  http.Response response =
      await http.post(apiUrl, headers: headers, body: body);
  final data = response.body;
  print(data);
  return data;
}

void main() async {
  // login('admin', '1234');
  registerUser('id', 'password', 'name');
}
