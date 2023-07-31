import 'package:latlong2/latlong.dart';

List<LatLng> fn(List<dynamic> a) {
  return (a.map((coordinate) => LatLng(coordinate[1], coordinate[0])).toList());
}
