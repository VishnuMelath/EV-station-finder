import 'dart:async';
import 'dart:convert';

import 'package:ev/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../function/dynaimctolist.dart';
import '../function/station.dart';

class MapScreen extends StatefulWidget {
  String id;
  MapScreen({super.key, required this.id});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<LatLng> routeCoordinates = [];
  MapController mapController = MapController();
  LatLng start = LatLng(10.9254, 79.8380);
  bool test = false;
  bool show = false;
  List<Marker> stations = <Marker>[];
  late LatLng location;
  late StreamSubscription<Position> positionStream;
  @override
  void initState() {
    _fetchStations();
    // _showSnackBar('test');
    positionStream = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter:
              10), // min distance (in meters) to travel before updates are sent
    ).listen((position) {
      setState(() {
        start = LatLng(position.latitude, position.longitude);
        test = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    positionStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          mapController.move(start, 14.0);
          setState(() {
            mapController.rotate(0);
          });
        },
        child: const Icon(Icons.my_location),
      ),
      body: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: start,
            zoom: 10,
            rotation: 0,
            maxZoom: 18.4,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate:
                  'https://api.maptiler.com/maps/streets-v2/256/{z}/{x}/{y}@2x.png?key=qxb5mCoEZUUz7cc3pwsw',
              subdomains: ['a', 'b', 'c'],
            ),
            // if (show)
            //   PolylineLayerOptions(
            //     polylines: [
            //       Polyline(
            //         points: routeCoordinates,
            //         strokeWidth: 7.0,
            //         color: Colors.blue,
            //       ),
            //     ],
            //   ),
            MarkerLayerOptions(
              markers: [
                for (final data in stations) data,
                if (test)
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: start,
                    builder: (ctx) => GestureDetector(
                      child: const Icon(
                        Icons.circle_rounded,
                        color: Color.fromARGB(170, 253, 251, 251),
                        shadows: [
                          BoxShadow(
                              color: Color.fromARGB(255, 5, 15, 147),
                              blurRadius: 40,
                              spreadRadius: 30),
                        ],
                        size: 30,
                      ),
                    ),
                  ),
              ],
            ),
          ]),
    );
  }

  // Stream<LatLng> _fetchCurrentPosition() async* {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition();
  //     // _showSnackBar(position.toString());
  //     start = LatLng(position.latitude, position.longitude);
  //     setState(() {
  //       test = true;
  //     });
  //     yield start;
  //   } catch (e) {
  //     _showSnackBar('Error getting current position');
  //   }
  // }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future _fetchStations() async {
    var markerData = await stationsData();

    for (int data = 0; data < markerData.length; data++) {
      var title = markerData[data]["AddressInfo"]["Title"];
      LatLng point = LatLng(markerData[data]["AddressInfo"]["Latitude"],
          markerData[data]["AddressInfo"]["Longitude"]);
      String address =
          "  ${markerData[data]["AddressInfo"]["AddressLine1"]}\n  ${markerData[data]["AddressInfo"]["Town"]}\n  ${markerData[data]["AddressInfo"]["StateOrProvince"]}\n  ${markerData[data]["AddressInfo"]["Country"]["Title"]}";
      List connections = markerData[data]["Connections"];
      // String status = markerData[data][""];
      final marker = Marker(
        point: point,
        // builder: (_) => Icon(Icons.location_pin),
        builder: (markercontext) => GestureDetector(
          onTap: () {
            showModalBottomSheet(
                isScrollControlled: true,
                useSafeArea: true,
                context: context,
                builder: (BuildContext contextbottomsheet) {
                  return SafeArea(
                    child: IntrinsicHeight(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              color: const Color.fromARGB(255, 39, 70, 57),
                              child: Column(children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("   \n$title",
                                            style: const TextStyle(
                                                fontSize: 30,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255))),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () =>
                                          Navigator.pop(contextbottomsheet),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                            "  ${markerData[0]["Connections"][0]["ConnectionType"]["Title"]}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ]),
                            ),
                            SafeArea(
                              child: Container(
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      style: BorderStyle.solid,
                                      color: const Color.fromARGB(
                                          99, 132, 127, 127)),
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                              144, 255, 255, 255)
                                          .withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.map),
                                      Text(
                                        "Address",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                                255, 60, 59, 59)),
                                      )
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(address),
                                  )
                                ]),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    style: BorderStyle.solid,
                                    color: const Color.fromARGB(
                                        99, 132, 127, 127)),
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(144, 255, 255, 255)
                                            .withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(children: [
                                Row(
                                  children: const [
                                    Icon(Icons.battery_1_bar),
                                    Text(
                                      "Equipment Details",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color:
                                              Color.fromARGB(255, 10, 10, 10)),
                                    )
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "   \nNumber of stations: ${markerData[0]["NumberOfPoints"]}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 60, 59, 59)),
                                  ),
                                ),
                                SafeArea(
                                    child: Column(
                                        children: List.generate(
                                            connections.length,
                                            (index) => Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: SizedBox(
                                                    child: Column(
                                                      children: [
                                                        const Divider(),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              "${connections[index]["ConnectionType"]["Title"]} "),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              "${connections[index]["PowerKW"]}"),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              "${connections[index]["CurrentType"]["Title"]}"),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              "Status :${connections[index]["StatusType"]["Title"]}"),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              "Total plug points: ${connections[index]["Quantity"]}"),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ))))
                              ]),
                            ),
                            Container(
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      style: BorderStyle.solid,
                                      color: const Color.fromARGB(
                                          99, 132, 127, 127)),
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                              144, 255, 255, 255)
                                          .withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.library_books),
                                      Text(
                                        "Usage Restrictions",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                                255, 10, 10, 10)),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              "Operational Status:  ${markerData[0]["StatusType"]["Title"]}"),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              "Usage:  ${markerData[0]["UsageType"]["Title"]}"),
                                        ),
                                      ],
                                    ),
                                  )
                                ])),
                            FutureBuilder<double>(
                                future: fetchRoute(start, point),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    default:
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text("error${snapshot.error}"),
                                        );
                                      } else {
                                        var dist = snapshot.data;
                                        var distance = dist!.round();
                                        var tempmeter =
                                            (dist - distance) * 1000;
                                        var meter = tempmeter.round();
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              child: Center(
                                                  child: Text(
                                                      "Distance from current location:$distance km $meter m",
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0)))),
                                            ),
                                            // Text('status : $'),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                  return RouteMap(
                                                    start: start,
                                                    destination: point,
                                                    routecoordinates:
                                                        routeCoordinates,
                                                    name: title,
                                                    id: widget.id,
                                                  );
                                                }));
                                              },
                                              style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(Colors
                                                            .white), // text color
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(const Color
                                                            .fromARGB(
                                                        255,
                                                        80,
                                                        148,
                                                        151)), // button background color
                                                padding: MaterialStateProperty.all<
                                                        EdgeInsetsGeometry>(
                                                    const EdgeInsets.all(
                                                        10)), // button padding
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: const BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 96, 125, 139)),
                                                  ),
                                                ), // button border radius and border color
                                              ),
                                              child: const Text("show route"),
                                            ),
                                          ],
                                        );
                                      }
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
          child:
              //  const
              // ImageIcon(
              // AssetImage(
              //     '/home/vishnu/Documents/flutter/ev/ev/assets/placeholder.png'),
              // color: Color.fromARGB(255, 26, 61, 28),
              // )
              const Icon(
            Icons.location_pin,
            color: Color.fromARGB(190, 13, 114, 55),
            size: 40,
          ),
        ),
      );
      stations.add(marker);
      // stationdist["$data"] = await _fetchRoute(_start.value, _end.value);
    }
    setState(() {
      stations;
    });
  }

  Future<double> fetchRoute(LatLng start, LatLng end) async {
    // Request location permission

    // var data1 = await _fetchRoutedata(start, end);
    const apiKey = '5b3ce3597851110001cf62487f069ea4a94542ef8718a3597447b8d1';
    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}';
    final response = await http.get(Uri.parse(url));
    final data1 = jsonDecode(response.body);

    final geometry = data1['features'][0]['geometry']['coordinates'];

    routeCoordinates = fn(geometry);
    double dist =
        (data1['features'][0]['properties']['segments'][0]['distance']) / 1000;
    double distance = dist;
    return distance;
  }
}
