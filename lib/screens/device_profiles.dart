import 'package:device_profiles/blocks/app_bloc.dart';
import 'package:device_profiles/constants.dart';
import 'package:device_profiles/models/device_Profile.dart';
import 'package:device_profiles/widgets/header_widget.dart';
import 'package:device_profiles/widgets/location_dialog.dart';
import 'package:device_profiles/widgets/side_nav.dart';
import 'package:device_profiles/widgets/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppBloc? appBloc;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      appBloc!.fetchAllProfiles();
    });
  }

  Widget profilesWidget() {
    return StreamBuilder(
        stream: appBloc!.deviceProfiles,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasData && snapshot.data!.length == 0)
            return Center(
              child: Text("It seems you did not create any themes yet"),
            );
          List<DeviceProfile> profiles = snapshot.data!;
          return Container(
            child: ListView.builder(
                itemCount: profiles.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DeviceProfile _profile = profiles[index];
                  return Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: figmaLightestGrey),
                          borderRadius: BorderRadius.circular(7)),
                      child: Column(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              right: 10, left: 10, top: 12, bottom: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Location Name: ${_profile.locationName}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              (appBloc!.currentProfile!.locationName ==
                                      _profile.locationName)
                                  ? Text(
                                      "Current Selected Profile",
                                      style: TextStyle(color: Colors.green),
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        appBloc!.changeCurrentProfile(
                                            id: _profile.locationName);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Current Profile successfully changed"),
                                        ));
                                        setState(() {});
                                      },
                                      child: Text("Set As Current Profile"))
                            ],
                          ),
                        ),
                        Divider(
                          height: 0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Latitude:"),
                                  Text("${_profile.loc.latitude}")
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text("Longitude:"),
                                  Text("${_profile.loc.longitude}")
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 0),
                        Padding(
                          padding: EdgeInsets.only(
                              right: 10, left: 10, top: 12, bottom: 12),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Theme',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Text("Edit"),
                                      IconButton(
                                          onPressed: () => Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                  pageBuilder: (_, __, ___) =>
                                                      ThemeSettings(
                                                        deviceProfile: _profile,
                                                      ))),
                                          icon: Icon(Icons.edit)),
                                    ],
                                  )
                                ],
                              ),
                              Divider(
                                color: figmaLightestGrey,
                                height: 0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Text Size',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('${_profile.theme.textSize}')
                                ],
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Theme Color',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 3),
                                    decoration: BoxDecoration(
                                        color: Color(_profile.theme.themeColor),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      "${Color(_profile.theme.themeColor).toString()}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]));
                }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    appBloc ??= Provider.of<AppBloc>(context, listen: true);
    if (buildingForWebDesktop(context))
      return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
              child: Container(
                  child: Column(children: [
            HeaderWidget(),
            SizedBox(height: 0.5),
            Expanded(
                child: Stack(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: kSideNavWidth,
                ),
                Expanded(
                  child: Scaffold(
                      backgroundColor: bgColor,
                      appBar: AppBar(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        centerTitle: false,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Device Profiles",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: figmaBlack),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: figmaOrange,
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(200, 50)),
                                onPressed: () => Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            LocationScreen())),
                                child: Text("Add New Location"))
                          ],
                        ),
                      ),
                      body: Center(
                        child: Container(width: 600, child: profilesWidget()),
                      )),
                )
              ]),
              Align(
                  alignment: Alignment.centerLeft,
                  child: SideNav(LayoutPageEnum.profiles))
            ]))
          ]))));
    return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: figmaOrange,
                      foregroundColor: Colors.white,
                      minimumSize: Size.fromHeight(50)),
                  onPressed: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => LocationScreen())),
                  child: Text("ADD ANOTHER")),
              SizedBox(
                height: 20,
              ),
              Expanded(child: profilesWidget()),
            ],
          ),
        )));
  }
}
