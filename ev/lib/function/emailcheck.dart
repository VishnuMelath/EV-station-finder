import 'package:http/http.dart' as http;

void main(List<String> args) async {
  var url =
      "https://api.apilayer.com/email_verification/check?email=vishnumeloth13@gmail.com";

  var headers = {"apikey": "s9P9k7GnQq0ZIx7Q8gku3QMcmmp5m8ba"};

  var response = await http.get(Uri.parse(url), headers: headers);
  print(response.body);
}
