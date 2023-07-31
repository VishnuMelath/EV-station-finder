import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class UpdateStation extends StatefulWidget {
  const UpdateStation({super.key});

  @override
  State<UpdateStation> createState() => _UpdateStationState();
}

class _UpdateStationState extends State<UpdateStation> {
  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        hintText: 'Search station..',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
