import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 1)
class Places {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final double lat;
  @HiveField(2)
  final double long;
  Places({required this.name, required this.lat, required this.long});
}
