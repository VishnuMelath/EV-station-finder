import 'dart:convert';
import 'package:ev/config/global.dart';
import 'package:http/http.dart' as http;

// Replace with your own API key
Future getUserData(String id) async {
  var ip = await printIps();
  Uri apiUrl1 = Uri.parse('http://$ip:8080/userdata');
  Map<String, String> headers1 = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  Map<String, String> body1 = {
    'email': 'vishnumeloth@gmail.com',
  };
  http.Response response1 =
      await http.post(apiUrl1, headers: headers1, body: body1);
  final data1 = jsonDecode(response1.body);
  print(data1);
}

void main(List<String> args) async {
  await getUserData('vishnumeloth@gmail.com');
}
