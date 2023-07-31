import 'package:ev/admin/adminhome.dart';
import 'package:ev/widgets/splashscreen.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const AdminHome(),
      darkTheme: ThemeData.dark(),
    );
  }
}
