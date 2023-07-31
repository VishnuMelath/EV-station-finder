// import 'dart:convert';
// import 'package:ev/widgets/homescreen.dart';
// import 'package:flutter/material.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:http/http.dart' as http;
// import '../function/dynaimctolist.dart';

// List<LatLng> routeCoordinates = [];
// List<LatLng> route = [];
// final ValueNotifier<bool> test = ValueNotifier(false);
// ValueNotifier<String> distance = ValueNotifier("loading");

// bottomsheet(
//     LatLng current, String name, LatLng location, BuildContext context) async {
//   showModalBottomSheet(
//       context: context,
//       builder: (BuildContext contextbottomsheet) {
//         return Container(
//           width: double.infinity,
//           color: Colors.white,
//           child: Column(
//             children: [
//               Text("\n\n$name\n\n${distance.value} km"),
//               TextButton(
//                 onPressed: () async {
//                   await _fetchRoute(current, location);
//                   Navigator.pop(contextbottomsheet);
//                   showRoute(routeCoordinates, distance.value, current);
//                 },
//                 style: ButtonStyle(
//                   foregroundColor: MaterialStateProperty.all<Color>(
//                       Colors.white), // text color
//                   backgroundColor: MaterialStateProperty.all<Color>(
//                       Colors.blue), // button background color
//                   padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//                       const EdgeInsets.all(10)), // button padding
//                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(18.0),
//                       side: const BorderSide(color: Colors.blue),
//                     ),
//                   ), // button border radius and border color
//                 ),
//                 child: const Text("show route"),
//               )
//             ],
//           ),
//         );
//       });
// }

// Future<void> _fetchRoute(LatLng start, LatLng end) async {
//   // Request location permission

//   // var data1 = await _fetchRoutedata(start, end);
//   const apiKey = '5b3ce3597851110001cf62487f069ea4a94542ef8718a3597447b8d1';
//   final url =
//       'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}';
//   final response = await http.get(Uri.parse(url));
//   final data1 = jsonDecode(response.body);

//   final geometry = data1['features'][0]['geometry']['coordinates'];

//   routeCoordinates = fn(geometry);
//   double dist =
//       (data1['features'][0]['properties']['segments'][0]['distance']) / 1000;
//   distance.value = dist.toString();
// }
