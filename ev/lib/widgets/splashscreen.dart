import 'dart:async';
import 'package:ev/widgets/login.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

late LatLng currentsplash;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
    Timer(const Duration(seconds: 2), () {});
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: locationPermission(),
        builder: (context, snap) {
          return Scaffold(
            backgroundColor: Colors.blueGrey,
            body: Center(
              child: RotationTransition(
                turns: _animation,
                child: Icon(
                  Icons.flash_on,
                  size: 100,
                  color: Colors.yellow[700],
                ),
              ),
            ),
          );
        });
  }

  Future locationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('enable location permission');
          openAppSettings();
        }
      } else {
        bool serviceenabled = await Geolocator.isLocationServiceEnabled();
        if (serviceenabled) {
          Position location = await Geolocator.getCurrentPosition();
          currentsplash = LatLng(location.latitude, location.longitude);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Login()));
        } else {
          _showLocationAlertDialog(context);
          // locationPermission();
        }
      }
      // Position position = await Geolocator.getCurrentPosition();
      // _showSnackBar(position.toString());
    } catch (e) {
      _showSnackBar('Error getting current position');
    }
  }

  void _showLocationAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location services disabled'),
          content: Text('Please enable location services to use this feature.'),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('SETTINGS'),
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
                locationPermission();
              },
            ),
          ],
        );
      },
    );
  }
}
