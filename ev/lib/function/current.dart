import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

Future<LatLng> loc() async {
  LatLng start = LatLng(12.4996, 74.9869);
  final permissionStatus = await Permission.location.request();
  if (permissionStatus != PermissionStatus.granted) {
    return start;
  }

  try {
    Position position = await Geolocator.getCurrentPosition();
    LatLng start = LatLng(position.latitude, position.longitude);
    return start;
  } catch (e) {
    return start;
  }
}

void main(List<String> args) async {}
