import 'dart:async';
import 'dart:convert';

import 'package:ev/widgets/route.dart';
import 'package:ev/widgets/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../function/dynaimctolist.dart';

class StationTile extends StatefulWidget {
  List markerData;
  int index;
  String id;

  StationTile(
      {super.key,
      required this.markerData,
      required this.index,
      required this.id});

  @override
  State<StationTile> createState() => _StationTileState();
}

class _StationTileState extends State<StationTile> {
  List<LatLng> routeCoordinates = [];
  late String title;
  late LatLng location;
  late String place;
  late StreamSubscription<Position> positionStream;
  late double distance;
  late List markerData;
  bool check = false;
  late int index;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // place = widget.place;
    // title = widget.name;
    // location = widget.location;
    index = widget.index;
    markerData = widget.markerData;
    place = markerData[index]["AddressInfo"]["AddressLine1"];
    title = markerData[index]["AddressInfo"]["Title"];
    location = LatLng(markerData[index]["AddressInfo"]["Latitude"],
        markerData[index]["AddressInfo"]["Longitude"]);
    // fetchRoute(currentsplash, location).then((value) => check = true);
  }

  @override
  Widget build(BuildContext context) {
    String address =
        "  ${markerData[index]["AddressInfo"]["AddressLine1"]}\n  ${markerData[index]["AddressInfo"]["Town"]}\n  ${markerData[index]["AddressInfo"]["StateOrProvince"]}\n  ${markerData[index]["AddressInfo"]["Country"]["Title"]}";
    List connections = markerData[index]["Connections"];
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
                child:
                    Align(alignment: Alignment.centerLeft, child: Text(title))),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: () {
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
                                      color:
                                          const Color.fromARGB(255, 39, 70, 57),
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
                                                            255,
                                                            255,
                                                            255,
                                                            255))),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () => Navigator.pop(
                                                  contextbottomsheet),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text("  $title",
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
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                      144, 255, 255, 255)
                                                  .withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
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
                                            child: Text(place),
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    144, 255, 255, 255)
                                                .withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
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
                                                  color: Color.fromARGB(
                                                      255, 10, 10, 10)),
                                            )
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "   \nNumber of stations: ${markerData[index]["NumberOfPoints"]}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 60, 59, 59)),
                                          ),
                                        ),
                                        SafeArea(
                                            child: Column(
                                                children: List.generate(
                                                    connections.length,
                                                    (index) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: SizedBox(
                                                            child: Column(
                                                              children: [
                                                                const Divider(),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      "${connections[index]["ConnectionType"]["Title"]} "),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      "${connections[index]["PowerKW"]}"),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      "${connections[index]["CurrentType"]["Title"]}"),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      "Status :${connections[index]["StatusType"]["Title"]}"),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
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
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                      144, 255, 255, 255)
                                                  .withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      "Operational Status:  ${markerData[0]["StatusType"]["Title"]}"),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      "Usage:  ${markerData[0]["UsageType"]["Title"]}"),
                                                ),
                                              ],
                                            ),
                                          )
                                        ])),
                                    FutureBuilder<double>(
                                        future:
                                            fetchRoute(currentsplash, location),
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            default:
                                              if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                      "error${snapshot.error}"),
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
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0)))),
                                                    ),
                                                    // Text('status : $'),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                          return RouteMap(
                                                            id: widget.id,
                                                            start:
                                                                currentsplash,
                                                            destination:
                                                                location,
                                                            routecoordinates:
                                                                routeCoordinates,
                                                            name: title,
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
                                                                39,
                                                                70,
                                                                57)), // button background color
                                                        padding: MaterialStateProperty.all<
                                                                EdgeInsetsGeometry>(
                                                            const EdgeInsets
                                                                    .all(
                                                                10)), // button padding
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0),
                                                            side: const BorderSide(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        39,
                                                                        70,
                                                                        57)),
                                                          ),
                                                        ), // button border radius and border color
                                                      ),
                                                      child: const Text(
                                                          "show route"),
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
                  icon: const Icon(Icons.info)),
            )
          ],
        ),
      ),
    );
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
