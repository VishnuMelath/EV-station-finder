import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

// class ChargingStation {
//   String id;
//   String name;
//   double latitude;
//   double longitude;

//   ChargingStation({
//     required this.id,
//     required this.name,
//     required this.latitude,
//     required this.longitude,
//   });
// }

void main() async {
  LatLng start = LatLng(13.0080105785156, 79.9967302801109);
  var headers = {'User-Agent': 'My Custom User Agent'};
  String key = "c3f03625-53cc-4787-845b-0c4f1126aeb4";
  var url =
      'https://api.openchargemap.io/v3/poi/?output=json&latitude=${start.latitude}&longitude=${start.longitude}&distance=100000&distanceunit=KM&&maxresults=1&key=$key';
  var response = await http.get(Uri.parse(url), headers: headers);

  final data = jsonDecode(response.body) as List<dynamic>;
  // print(data);

  // print(data.length);
  // print(data);
  // print(data[0]["AddressInfo"]["Title"]);
  // print(data[0]["AddressInfo"]["Longitude"]);
  print(data[0]["Connections"][0]["ConnectionType"]["Title"]);
  print(data[0]["UsageType"]["Title"]);

  print(data[0]["Connections"][0]);
  print(data[0]["Connections"][1]);
  print(data[0]["Connections"][2]);
  print(data[0]["NumberOfPoints"]);
  List connections = data[0]["Connections"];
  print(connections.length);
  for (final data1 in data[0]["Connections"]) {
    print(data1);
  }
}
