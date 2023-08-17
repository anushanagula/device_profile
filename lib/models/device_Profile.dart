import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'device_Profile.g.dart';

@HiveType(typeId: 0)
class DeviceProfile extends HiveObject {
  @HiveField(0)
  String locationName;
  @HiveField(1)
  Location loc;
  @HiveField(2)
  ProfileTheme theme;

  DeviceProfile(
      {required this.locationName, required this.loc, required this.theme});
}

@HiveType(typeId: 1)
class Location {
  @HiveField(0)
  final double latitude;
  @HiveField(1)
  final double longitude;

  Location({required this.latitude, required this.longitude});
}

@HiveType(typeId: 2)
class ProfileTheme {
  @HiveField(0)
  int themeColor; //hexcode
  @HiveField(1)
  double textSize;

  ProfileTheme({required this.themeColor, required this.textSize});
}
