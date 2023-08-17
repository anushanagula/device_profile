import 'package:device_profiles/models/device_Profile.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc {
  BehaviorSubject<List<DeviceProfile>> _deviceProfiles =
      BehaviorSubject<List<DeviceProfile>>();
  Stream<List<DeviceProfile>> get deviceProfiles => _deviceProfiles.stream;

  BehaviorSubject<DeviceProfile> _currentProfile =
      BehaviorSubject<DeviceProfile>();
  Stream<DeviceProfile> get currentProfileStream => _currentProfile.stream;
  DeviceProfile? currentProfile;

  List<DeviceProfile> availableDeviceProfiles() {
    return _deviceProfiles.hasValue ? _deviceProfiles.value : [];
  }

  void fetchAllProfiles() async {
    var box = Hive.box<DeviceProfile>('device_profiles');
    List<DeviceProfile> profiles = box.values.toList();
    _deviceProfiles.add(profiles);
  }

  void addprofile(
      {required String id,
      required Location location,
      required ProfileTheme profileTheme,
      bool changeToCurrent = false}) async {
    DeviceProfile newProfile =
        DeviceProfile(locationName: id, loc: location, theme: profileTheme);
    var box = Hive.box<DeviceProfile>('device_profiles');
    box.put(id, newProfile);
    List<DeviceProfile> profiles =
        _deviceProfiles.hasValue ? _deviceProfiles.value : [];
    profiles.add(newProfile);
    _deviceProfiles.add(profiles);
    if (changeToCurrent) changeCurrentProfile(id: id);
  }

  void updateProfile(
      {required String id,
      int? themeColor,
      double? textSize,
      bool changeToCurrent = false}) async {
    var box = Hive.box<DeviceProfile>('device_profiles');
    DeviceProfile? profile = box.get(id);
    if (themeColor != null) profile?.theme.themeColor = themeColor;
    if (textSize != null) profile?.theme.textSize = textSize;
    box.put(id, profile!);
    if (changeToCurrent) changeCurrentProfile(id: id);
  }

  void deleteProfile({required String id}) {
    var box = Hive.box<DeviceProfile>('device_profiles');
    box.delete(id);
  }

  void changeCurrentProfile({required String id}) async {
    var box = await Hive.openBox('UI');
    box.put("cuurentDeviceProfile", id);
    var box1 = Hive.box<DeviceProfile>('device_profiles');
    DeviceProfile? d = box1.get(id);
    _currentProfile.add(d!);
    currentProfile = d;
  }

  Future<void> getCurrentProfile() async {
    var box = await Hive.openBox('UI');
    String? id = box.get("cuurentDeviceProfile");
    if (id != null) {
      var box1 = Hive.box<DeviceProfile>('device_profiles');
      DeviceProfile? d = box1.get(id);
      _currentProfile.add(d!);
      currentProfile = d;
    }
  }
}
