import 'package:flutter/material.dart';

class Location {
  String locationName;
  final double latitude;
  final double longitude;

  Location(
      {required this.locationName,
      required this.latitude,
      required this.longitude});
}
