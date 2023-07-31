import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:ev/widgets/bottomnav.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/global.dart';

bool test = false;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    TextEditingController usrname = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController repassword = TextEditingController();
    TextEditingController email = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Register',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: usrname,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                  labelText: 'Name',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: email,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintText: 'email',
                  labelText: 'email',
                ),
              ),
            ),
            const Divider(),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                  labelText: 'Password',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: repassword,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintText: 'Retype Password',
                  labelText: 'Retype Password',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 300,
              child: Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if (password.text == repassword.text) {
                      await register(
                          email.text, password.text, usrname.text, context);
                      if (test) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return NavBottom(id: email.text);
                        }));
                      } else {}
                    } else {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                            content:
                                Text('password and re password doesnt match!')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  register(
      String id, String password, String name, BuildContext context1) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context1);
    List<int> bytes = utf8.encode(password);
    Digest digest = sha256.convert(bytes);
    String hashPassword = digest.toString();
    var ip = await printIps();
    Uri apiUrl = Uri.parse('http://$ip:8080/register');
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
    if (data == 'true') {
      setState(() {
        test = true;
      });
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('already registred mail id!')),
      );
    }
  }
}
