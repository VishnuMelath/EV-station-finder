import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '../function/dynaimctolist.dart';
import 'bottomnav.dart';

class RouteMap extends StatefulWidget {
  LatLng start;
  LatLng destination;
  List<LatLng> routecoordinates;
  String name;
  String id;

  RouteMap(
      {super.key,
      required this.start,
      required this.destination,
      required this.routecoordinates,
      required this.name,
      required this.id});

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  late LatLng start;
  late LatLng destination;
  late int distance;
  late double tempmeter;
  late int meter;
  late String name;
  String direction = '';
  MapController mapController = MapController();
  late StreamSubscription<Position> positionStream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.name;
    start = widget.start;
    destination = widget.destination;
    positionStream = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter:
              10), // min distance (in meters) to travel before updates are sent
    ).listen((position) {
      setState(() {
        start = LatLng(position.latitude, position.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LatLng>>(
        stream: fetchRoute(start, destination),
        builder: (context, snapshot) {
          // var data = snapshot.data;
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                iconTheme:
                    const IconThemeData(color: Color.fromARGB(117, 0, 0, 0)),
                toolbarTextStyle:
                    const TextStyle(color: Color.fromARGB(136, 0, 0, 0)),
                leading: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NavBottom(
                                    id: widget.id,
                                  )))),
                ),
                toolbarHeight: 200,
                flexibleSpace: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "    $name\n",
                        style: const TextStyle(fontSize: 50),
                      ),
                    ),
                    Text(" After $distance km $meter m",
                        style: const TextStyle(fontSize: 20)),
                    Text(" $direction", style: const TextStyle(fontSize: 20))
                  ],
                ),
                backgroundColor: const Color.fromRGBO(255, 255, 255, 0.84),
                automaticallyImplyLeading: false,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  mapController.move(start, 18.0);
                  setState(() {
                    mapController.rotate(0);
                  });
                },
                child: const Icon(Icons.my_location),
              ),
              body: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    center: widget.start,
                    zoom: 15.4,
                    rotation: 0,
                    maxZoom: 18.4,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          'https://api.maptiler.com/maps/streets-v2/256/{z}/{x}/{y}@2x.png?key=qxb5mCoEZUUz7cc3pwsw',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    PolylineLayerOptions(
                      polylines: [
                        Polyline(
                          points: snapshot.data ?? widget.routecoordinates,
                          strokeWidth: 7.0,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: start,
                          builder: (ctx) => GestureDetector(
                            child: const Icon(
                              Icons.circle_rounded,
                              color: Color.fromARGB(151, 255, 255, 255),
                              shadows: [
                                BoxShadow(
                                    color: Color.fromARGB(255, 18, 5, 71),
                                    blurRadius: 30),
                              ],
                              size: 30,
                            ),
                          ),
                        ),
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: widget.destination,
                          builder: (ctx) => GestureDetector(
                              child: const Icon(
                            Icons.location_pin,
                            color: Color.fromARGB(251, 8, 113, 47),
                            size: 40,
                          )
                              //     const ImageIcon(
                              //   AssetImage(
                              //       '/home/vishnu/Documents/flutter/ev/ev/assets/ca.png'),
                              //   // color: Color.fromARGB(255, 26, 61, 28),
                              //   // size: 30,
                              // )
                              ),
                        ),
                      ],
                    ),
                  ]),
            );
          } else {
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          }
        });
  }

  Stream<List<LatLng>> fetchRoute(LatLng start, LatLng end) async* {
    // Request location permission

    // var data1 = await _fetchRoutedata(start, end);
    const apiKey = '5b3ce3597851110001cf62487f069ea4a94542ef8718a3597447b8d1';
    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}';
    var response = await http.get(Uri.parse(url));
    var data1 = jsonDecode(response.body);

    var geometry = data1['features'][0]['geometry']['coordinates'];

    var routeCoordinates = fn(geometry);
    double dist = (data1['features'][0]['properties']['segments'][0]['steps'][0]
            ['distance']) /
        1000;

    distance = dist.round();
    tempmeter = (dist - distance) * 1000;
    meter = tempmeter.round();
    direction = data1['features'][0]['properties']['segments'][0]['steps'][1]
        ['instruction'];
    yield routeCoordinates;
  }
}
