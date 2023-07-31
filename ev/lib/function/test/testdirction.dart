import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

void main() async {
  var start = LatLng(8.681495, 49.41461);
  final LatLng _end = LatLng(8.687872, 49.420318);
  const apiKey = '5b3ce3597851110001cf62487f069ea4a94542ef8718a3597447b8d1';
  final url =
      'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${_end.longitude},${_end.latitude}';
  final response = await http.get(Uri.parse(url));
  final data = jsonDecode(response.body);
  print(data);
  double distance =
      data['features'][0]['properties']['segments'][0]['distance'];
  var inst = data['features'][0]['properties']['segments'][0]['steps'][1]
      ['instruction'];
  print(distance / 1000);
  print(inst);
}
