// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_Profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceProfileAdapter extends TypeAdapter<DeviceProfile> {
  @override
  final int typeId = 0;

  @override
  DeviceProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceProfile(
      locationName: fields[0] as String,
      loc: fields[1] as Location,
      theme: fields[2] as ProfileTheme,
    );
  }

  @override
  void write(BinaryWriter writer, DeviceProfile obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.locationName)
      ..writeByte(1)
      ..write(obj.loc)
      ..writeByte(2)
      ..write(obj.theme);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocationAdapter extends TypeAdapter<Location> {
  @override
  final int typeId = 1;

  @override
  Location read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Location(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Location obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfileThemeAdapter extends TypeAdapter<ProfileTheme> {
  @override
  final int typeId = 2;

  @override
  ProfileTheme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileTheme(
      themeColor: fields[0] as int,
      textSize: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileTheme obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.themeColor)
      ..writeByte(1)
      ..write(obj.textSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
