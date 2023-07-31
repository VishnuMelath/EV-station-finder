import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:latlong2/latlong.dart';

Future<List> stationsData() async {
  Position position = await Geolocator.getCurrentPosition();
  LatLng start = LatLng(position.latitude, position.longitude);
  var headers = {'User-Agent': 'My Custom User Agent'};
  String key = "c3f03625-53cc-4787-845b-0c4f1126aeb4";
  var url =
      'https://api.openchargemap.io/v3/poi/?output=json&latitude=${start.latitude}&longitude=${start.longitude}&maxresults=1000&countrycode=IN&key=$key';
  var response = await http.get(Uri.parse(url), headers: headers);

  final data = jsonDecode(response.body) as List<dynamic>;
  return data;
}

void main(List<String> args) async {
  var data = await stationsData();
  print("$data\n\n");
}
