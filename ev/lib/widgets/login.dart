import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:ev/admin/adminhome.dart';
import 'package:ev/function/apis.dart';
import 'package:ev/widgets/bottomnav.dart';
import 'package:ev/widgets/register.dart';
import 'package:ev/widgets/stationbottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'mapscreen.dart';

String x = 'false';
late bool test;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final _controllerUser = TextEditingController();

  final _controllerP = TextEditingController();

  String message = '';
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    Timer(
      const Duration(seconds: 3),
      () {},
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
          child: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          // color: Color.fromARGB(232, 255, 255, 255),
          width: 250,
          height: 500,
          // ignore: prefer_const_literals_to_create_immutables
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              child: RotationTransition(
                turns: _animation,
                child: Icon(
                  Icons.flash_on,
                  size: 50,
                  color: Colors.yellow[700],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 250,
              height: 40,
              child: TextField(
                controller: _controllerUser,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintText: ' email',
                  labelText: 'mail id',
                ),
              ),
            ),
            // ignore: prefer_const_constructors
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 250,
              height: 40,
              child: TextField(
                controller: _controllerP,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'password',
                  labelText: 'password',
                ),
              ),
            ),
            SizedBox(
              height: 30,
              child: Text(message, style: const TextStyle(color: Colors.red)),
            ),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                  onPressed: () async {
                    if (_controllerP.text != '' || _controllerUser.text != '') {
                      await validate(
                          _controllerUser.text, _controllerP.text, context);
                      if (test == true) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context3) {
                          return NavBottom(
                            id: _controllerUser.text,
                          );
                        }));
                      }
                      if (test == false) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context3) {
                          return const AdminHome();
                        }));
                      } else {
                        setState(() {
                          message = "enter valid id and password";
                        });
                      }
                    } else {
                      setState(() {
                        message = 'enter user id and password';
                      });
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    iconColor: const Color.fromARGB(255, 175, 24, 24),
                  ),
                  child: const Text('login')),
            ),
            SizedBox(
              height: 40,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context3) {
                    return const Register();
                  }));
                },
                child: const Text('new user?'),
              ),
            ),
            const SizedBox(
              height: 100,
            )
          ]),
        ),
      )),
    );
  }

  validate(String id, String password, BuildContext context1) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context1);
    List<int> bytes = utf8.encode(password);
    Digest digest = sha256.convert(bytes);
    String hashPassword = digest.toString();
    Uri apiUrl = Uri.parse('http://192.168.0.104:8080/login');
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    Map<String, String> body = {
      'email': id,
      'password': hashPassword,
    };
    http.Response response =
        await http.post(apiUrl, headers: headers, body: body);
    final data = response.body;
    if (data != 'false') {
      if (data == 'admin') {
        setState(() {
          test = false;
        });
      } else {
        setState(() {
          test = true;
        });
      }
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Invalid credentials')),
      );
    }
  }
}
