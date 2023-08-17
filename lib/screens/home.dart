import 'package:device_profiles/blocks/app_bloc.dart';
import 'package:device_profiles/constants.dart';
import 'package:device_profiles/models/device_Profile.dart';
import 'package:device_profiles/widgets/header_widget.dart';
import 'package:device_profiles/widgets/location_dialog.dart';
import 'package:device_profiles/widgets/location_set_up_dialogbox.dart';
import 'package:device_profiles/widgets/side_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppBloc? appBloc;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc ??= Provider.of<AppBloc>(context, listen: true);

    Widget homeBody(DeviceProfile dp) {
      return Container(
        width: buildingForWebDesktop(context)
            ? MediaQuery.of(context).size.width - 100
            : MediaQuery.of(context).size.width - 50,
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Flex(
                direction: buildingForWebDesktop(context)
                    ? Axis.horizontal
                    : Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Want to navigate to other location. Use current location or enter location coordinates manually here",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: figmaOrange,
                          foregroundColor: Colors.white,
                          minimumSize: Size(200, 40)),
                      onPressed: () => Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => LocationScreen())),
                      child: Text("Enter manually"))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  color: Color(dp.theme.themeColor),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        '''Hii, The current profile is:     ${dp.locationName} 
The location coordinates are:
Latitude: ${dp.loc.latitude}
Longitude: ${dp.loc.longitude}
theme Settings are:
font size: ${dp.theme.textSize}
theme color: Same as the background color''',
                        style: TextStyle(color: Colors.white),
                        softWrap: true,
                      ),
                    )
                  ]),
            ),
            Text(
              TEXTMESSAGE,
              style: TextStyle(
                color: Color(dp.theme.themeColor),
                fontSize: dp.theme.textSize,
              ),
              softWrap: true,
            ),
          ],
        ),
      );
    }

    if (buildingForWebDesktop(context))
      return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
              child: Container(
                  child: Column(children: [
            HeaderWidget(),
            SizedBox(height: 0.5),
            StreamBuilder<DeviceProfile>(
                stream: appBloc!.currentProfileStream,
                builder: (context, snapshot) {
                  DeviceProfile? _deviceProfile = snapshot.data;
                  return Expanded(
                      child: Stack(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        width: kSideNavWidth,
                      ),
                      _deviceProfile == null
                          ? LocationSetUpDialog()
                          : SingleChildScrollView(
                              child: homeBody(_deviceProfile!))
                    ]),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: SideNav(LayoutPageEnum.dashboard))
                  ]));
                })
          ]))));
    return Scaffold(
        backgroundColor: bgColor,
        body: StreamBuilder<DeviceProfile>(
            stream: appBloc!.currentProfileStream,
            builder: (context, snapshot) {
              DeviceProfile? _deviceProfile = appBloc!.currentProfile;
              return SafeArea(
                  child: _deviceProfile == null
                      ? LocationSetUpDialog()
                      : SingleChildScrollView(
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            homeBody(_deviceProfile),
                          ],
                        )));
            }));
  }
}
