import 'dart:io';

void main() {
  File file = File('/home/vishnu/Documents/flutter/ev/assets/IN.txt');
  List<Map<String, dynamic>> locations = [];

  file.readAsLines().then((List<String> lines) {
    late double lat1;
    int temp = 5;
    for (String line in lines) {
      int i;
      List<String> parts = line.split('\t');
      for (i = 1; i < parts.length;) {
        try {
          lat1 = double.parse(parts[i]);
          temp = i;
          break;
        } catch (e) {
          i++;
        }
      }
      String name = parts[1];
      double lat = lat1;
      double long = double.parse(parts[temp + 1]);
      Map<String, dynamic> location = {
        'name': name,
        'latitude': lat,
        'longitude': long,
      };
      locations.add(location);
    }
  });
}
