import 'dart:async';
import 'package:device_profiles/blocks/app_bloc.dart';
import 'package:device_profiles/constants.dart';
import 'package:device_profiles/screens/about_us.dart';
import 'package:device_profiles/screens/device_profiles.dart';
import 'package:device_profiles/screens/home.dart';
import 'package:device_profiles/widgets/botton_nav.dart';
import 'package:device_profiles/widgets/side_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  final int? page;
  RootScreen({this.page});

  @override
  _RootScreenState createState() => _RootScreenState(currentPage: page);
}

class _RootScreenState extends State<RootScreen> {
  ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  AppBloc? appBloc;
  bool exitTappedOnce = false;

  _RootScreenState({int? currentPage}) {
    if (currentPage != null) _currentPage.value = currentPage;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appBloc ??= Provider.of<AppBloc>(context);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: ValueListenableBuilder(
            valueListenable: _currentPage,
            builder: (_, int pageNo, __) {
              return _getPage(pageNo);
            }),
        bottomNavigationBar: SafeArea(
            child: BottomNav(
          currentPage: _currentPage,
        )),
      ),
    );
  }

  Widget _getPage(int pageNo) {
    switch (pageNo) {
      // case 5: return UsersManagementScreen();
      case 2:
        SystemNavigator.routeInformationUpdated(location: ABOUT_US);
        return AboutUs();
      case 1:
        SystemNavigator.routeInformationUpdated(location: PROFILE_LAYOUT);
        return ProfileScreen();
      case 0:
      default:
        SystemNavigator.routeInformationUpdated(location: DASHBOARD_LAYOUT);
        return HomeScreen();
    }
  }

  Future<bool> alert(BuildContext context) async {
    return await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black26,
        builder: (context) => Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Are you sure, you want to exit?",
                      style: TextStyle(fontSize: 16)),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: InkWell(
                        onTap: () => Navigator.pop(context, true),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: medColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            "Yes",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: InkWell(
                        onTap: () => Navigator.pop(context, false),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: figmaLightestGrey),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            "No",
                            style: TextStyle(color: figmaLightestGrey),
                          ),
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ));
  }
}
