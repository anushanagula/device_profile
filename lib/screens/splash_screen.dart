import 'package:device_profiles/blocks/app_bloc.dart';
import 'package:device_profiles/constants.dart';
import 'package:device_profiles/screens/home.dart';
import 'package:device_profiles/screens/root_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AppBloc? appBloc;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), proceed);
  }

  void proceed() async {
    appBloc!.fetchAllProfiles();
    await appBloc!.getCurrentProfile();
    if (buildingForWebDesktop(context)) {
      Navigator.pushReplacement(
          context, PageRouteBuilder(pageBuilder: (_, __, ___) => HomeScreen()));
    } else
      Navigator.pushReplacement(
          context, PageRouteBuilder(pageBuilder: (_, __, ___) => RootScreen()));
  }

  @override
  Widget build(BuildContext context) {
    appBloc ??= Provider.of<AppBloc>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Logo.jpg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "DEMO",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'OpenSans',
                      color: figmaBlack),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
