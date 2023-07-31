import 'dart:convert';

import 'package:crypto/crypto.dart';

void main() {
  var password = 'password';
  List<int> bytes = utf8.encode(password);
  Digest digest = sha256.convert(bytes);
  String hashPassword = digest.toString();
  print(hashPassword);
}
