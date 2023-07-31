import 'package:ev/widgets/mapscreen.dart';
import 'package:ev/widgets/profile.dart';
import 'package:ev/widgets/nearbystations.dart';
import 'package:flutter/material.dart';

class NavBottom extends StatefulWidget {
  String id;
  NavBottom({super.key, required this.id});
  @override
  State<NavBottom> createState() => _NavBottomState();
}

class _NavBottomState extends State<NavBottom> {
  late String id;
  late List _pages;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = widget.id;
    _pages = [
      MapScreen(
        id: id,
      ),
      Search(
        id: id,
      ),
      Profile(id: id)
    ];
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext contextbottomnav) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'nearby'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile')
          ]),
    );
  }
}
