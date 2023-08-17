import 'package:device_profiles/screens/device_profiles.dart';
import 'package:device_profiles/screens/home.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

enum LayoutPageEnum { dashboard, profiles }

const double kSideNavWidth = 85;

const DASHBOARD_LAYOUT = "dashboard";
const PROFILE_LAYOUT = "profiles";
const ABOUT_US = "about_us";

class SideNav extends StatelessWidget {
  final LayoutPageEnum page;
  SideNav(this.page);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: kSideNavWidth,
        child: Material(
            shadowColor: bgShadowColor,
            elevation: 2,
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    InkWell(
                      hoverColor: Colors.orange[100],
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) => HomeScreen(),
                                settings:
                                    RouteSettings(name: DASHBOARD_LAYOUT)),
                            (route) => !route.isFirst);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            page == LayoutPageEnum.dashboard
                                ? Icon(
                                    Icons.space_dashboard,
                                    color: figmaOrange,
                                  )
                                : Icon(Icons.space_dashboard_outlined,
                                    color: Color(0xff7C7C7C)),
                            Text(
                              "Dashboard",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: page == LayoutPageEnum.dashboard
                                      ? figmaOrange
                                      : Color(0xff7C7C7C),
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.clip,
                              softWrap: false,
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 3,
                                    color: page == LayoutPageEnum.dashboard
                                        ? figmaOrange
                                        : Colors.transparent))),
                      ),
                    ),
                    InkWell(
                      hoverColor: Colors.orange[100],
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) => ProfileScreen(),
                                settings: RouteSettings(name: PROFILE_LAYOUT)),
                            (route) => !route.isFirst);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            page == LayoutPageEnum.profiles
                                ? Icon(
                                    Icons.save_outlined,
                                    color: figmaOrange,
                                  )
                                : Icon(Icons.save, color: Color(0xff7C7C7C)),
                            Text(
                              "Profiles",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: page == LayoutPageEnum.profiles
                                      ? figmaOrange
                                      : Color(0xff7C7C7C),
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.clip,
                              softWrap: false,
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 3,
                                    color: page == LayoutPageEnum.profiles
                                        ? figmaOrange
                                        : Colors.transparent))),
                      ),
                    ),
                  ])
                ])));
  }
}
