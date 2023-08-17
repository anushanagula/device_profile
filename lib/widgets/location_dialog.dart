import 'package:device_profiles/blocks/app_bloc.dart';
import 'package:device_profiles/constants.dart';
import 'package:device_profiles/models/device_Profile.dart';
import 'package:device_profiles/screens/home.dart';
import 'package:device_profiles/screens/root_screen.dart';
import 'package:device_profiles/widgets/header_widget.dart';
import 'package:device_profiles/widgets/side_nav.dart';
import 'package:device_profiles/widgets/theme_color.dart';
import 'package:device_profiles/widgets/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

extension Range on num {
  bool isBetween(num from, num to) {
    return from < this && this < to;
  }
}

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();
  TextEditingController _locationNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AppBloc? appBloc;

  bool areEqual(double lat, double lon) {
    double? newlat = double.tryParse(_latitudeController.text);
    double? newlon = double.tryParse(_longitudeController.text);
    if (newlat != null && newlon != null) {
      double latdiff = newlat - lat;
      double londiff = newlon - lon;
      return latdiff.isBetween(-1, 1) && londiff.isBetween(-1, 1);
    }
    return false;
  }

  void onSubmit() async {
    if (_formKey.currentState!.validate()) {
      var box = Hive.box<DeviceProfile>('device_profiles');
      if (box.get(_locationNameController.text) != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "The Location name is already taken",
          style: TextStyle(color: Colors.white),
        )));
      } else {
        List<DeviceProfile> d = appBloc!.availableDeviceProfiles();
        String? id;
        for (int i = 0; i < d.length; i++) {
          DeviceProfile x = d[i];
          if (areEqual(x.loc.latitude, x.loc.longitude)) {
            id = x.locationName;
          }
        }
        if (id != null) {
          appBloc!.changeCurrentProfile(id: id);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Location changed successfully")));
          Navigator.pop(context);
        } else {
          double lat = double.tryParse(_latitudeController.text) ?? 14.5;
          double lon = double.tryParse(_longitudeController.text) ?? 14.5;
          DeviceProfile newProfile = DeviceProfile(
              locationName: _locationNameController.text,
              loc: Location(latitude: lat, longitude: lon),
              theme: ProfileTheme(textSize: 12, themeColor: figmaOrange.value));
          Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => ThemeSettings(
                        deviceProfile: newProfile,
                      )));
        }
      }
    }
  }

  Widget _locationWidget() {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          "Location",
          style: TextStyle(fontWeight: FontWeight.w600, color: figmaBlack),
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          width: 600,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  buildingForWebDesktop(context) ? 10 : 0),
              color: Colors.white),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      validator: (input) =>
                          (input!.isEmpty) ? "Enter location name" : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _locationNameController,
                      decoration: InputDecoration(
                          labelText: "Location Name",
                          labelStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: bgColor)),
                          contentPadding: EdgeInsets.all(5.0)),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (input) =>
                          !(double.tryParse(input ?? "")?.isBetween(-90, 90) ??
                                  false)
                              ? "Invalid Latitude"
                              : null,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+){0,3}\.?\d{0,100}'))
                      ],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _latitudeController,
                      decoration: InputDecoration(
                          labelText: "Latitude Coordinate",
                          labelStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: bgColor)),
                          contentPadding: EdgeInsets.all(5.0)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (input) => !(double.tryParse(input ?? "")
                                  ?.isBetween(-180, 180) ??
                              false)
                          ? "Invalid Longitude"
                          : null,
                      controller: _longitudeController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          labelText: "Longitude Coordinate",
                          labelStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: bgColor)),
                          contentPadding: EdgeInsets.all(5.0)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Latitude coordinates must be between [-90,90]"),
                    Text("Longitude coordinates must be in range [-180,180)")
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: Size.fromHeight(60)),
                    onPressed: () => onSubmit(),
                    child: Text("ADD/CHANGE"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    appBloc ??= Provider.of<AppBloc>(context, listen: true);
    if (buildingForWebDesktop(context))
      return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Container(
              child: Column(
            children: [
              HeaderWidget(),
              SizedBox(height: 0.5),
              Expanded(
                child: Stack(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: kSideNavWidth,
                        ),
                        Expanded(child: _locationWidget())
                      ],
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: SideNav(LayoutPageEnum.dashboard))
                  ],
                ),
              ),
            ],
          )),
        ),
      );
    else
      return _locationWidget();
  }
}
