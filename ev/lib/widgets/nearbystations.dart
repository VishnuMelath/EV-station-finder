import 'dart:async';

import 'package:ev/models/models.dart';

import 'package:ev/widgets/stationtilewidget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../function/station.dart';

class Search extends StatefulWidget {
  String id;
  Search({super.key, required this.id});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late LatLng start;
  late StreamSubscription<Position> positionStream;
  // late List<dynamic> st;

  bool check = false;
  @override
  void initState() {
    super.initState();
    // _fetchStations().then((value) => check = true);
  }

  @override
  Widget build(BuildContext context) {
    //
    return FutureBuilder<List>(
        future: _fetchStations(),
        builder: (context, snap) {
          switch (snap.connectionState) {
            case ConnectionState.waiting:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            default:
              if (!snap.hasError) {
                var st = snap.data;
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("nearesrt stations:"),
                  ),
                  body: ListView.builder(
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            StationTile(
                              markerData: st!,
                              index: index,
                              id: widget.id,
                            ),
                            const Divider(),
                          ],
                        );
                      }),
                );
              } else {
                return Scaffold(
                  body: Center(
                    child: Text(snap.error.toString()),
                  ),
                );
              }
          }
        });
  }

  Future<List<dynamic>> _fetchStations() async {
    var markerData = await stationsData();
    // var tiles = [];
    // for (int data = 0; data < 20; data++) {
    //   // var title = markerData[data]["AddressInfo"]["Title"];
    //   // LatLng point = LatLng(markerData[data]["AddressInfo"]["Latitude"],
    //   //     markerData[data]["AddressInfo"]["Longitude"]);
    //   // String place = markerData[data]["AddressInfo"]["AddressLine1"];
    //   // Stations stationdata = Stations(point, title, place);
    //   var stationdata = markerData[data];
    //   tiles.add(stationdata);
    // }
    return markerData;
    // setState(() {});
  }
}
