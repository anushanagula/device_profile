import 'package:device_profiles/blocks/app_bloc.dart';
import 'package:device_profiles/constants.dart';
import 'package:device_profiles/models/device_Profile.dart';
import 'package:device_profiles/screens/home.dart';
import 'package:device_profiles/screens/root_screen.dart';
import 'package:device_profiles/widgets/header_widget.dart';
import 'package:device_profiles/widgets/side_nav.dart';
import 'package:device_profiles/widgets/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class ThemeSettings extends StatefulWidget {
  final DeviceProfile? deviceProfile;
  const ThemeSettings({this.deviceProfile, super.key});

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  AppBloc? appBloc;
  ValueNotifier<double> textSize = ValueNotifier<double>(12);
  ValueNotifier<int> themeColor = ValueNotifier<int>(figmaOrange.value);
  Color? _currentThemeColor;
  bool isChecked = false;

  @override
  void initState() {
    if (widget.deviceProfile != null) {
      textSize.value = widget.deviceProfile!.theme.textSize;
      themeColor.value = widget.deviceProfile!.theme.themeColor;
    }
    super.initState();
  }

  void onSubmit() async {
    List<DeviceProfile> d = appBloc!.availableDeviceProfiles();
    bool isUniqueTheme = true;
    for (int i = 0; i < d.length; i++) {
      ProfileTheme x = d[i].theme;
      if (x.textSize == textSize.value && x.themeColor == themeColor.value) {
        isUniqueTheme = false;
        break;
      }
    }
    if (isUniqueTheme) {
      widget.deviceProfile!.theme =
          ProfileTheme(themeColor: themeColor.value, textSize: textSize.value);
      var box = Hive.box<DeviceProfile>('device_profiles');
      if (box.get(widget.deviceProfile!.locationName) != null)
        appBloc!.updateProfile(
            changeToCurrent: isChecked,
            id: widget.deviceProfile!.locationName,
            themeColor: themeColor.value,
            textSize: textSize.value);
      else
        appBloc!.addprofile(
            changeToCurrent: isChecked,
            id: widget.deviceProfile!.locationName,
            location: widget.deviceProfile!.loc,
            profileTheme: widget.deviceProfile!.theme);
      if (buildingForWebDesktop(context))
        Navigator.pushReplacement(context,
            PageRouteBuilder(pageBuilder: (_, __, ___) => HomeScreen()));
      else
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => RootScreen(
                      page: 0,
                    )));
    } else
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("There is a similar theme already.Please use unique settings"),
      ));
  }

  void setTheme() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0)),
            child: Container(
              // Height and width are forced only on large enough screens
              color: Colors.white,
              width: 700.0,
              height: 700.0,
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 16.0, left: 10.0, right: 10),
              child: ThemeManager(
                currentColor: Color(themeColor.value),
                setThemeColor: (int hexCode) {
                  themeColor.value = hexCode;
                  Navigator.pop(context);
                },
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    appBloc ??= Provider.of<AppBloc>(context, listen: true);
    _currentThemeColor = Color(appBloc!.currentProfile != null
        ? appBloc!.currentProfile!.theme.themeColor
        : figmaOrange.value);

    Widget textSizeInput = Container(
        child: TextFormField(
      initialValue: textSize.value.toString(),
      onChanged: (val) {
        textSize.value = double.tryParse(val) ?? textSize.value;
      },
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^(\d+){0,3}\.?\d{0,100}'))
      ],
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        hintText: "Enter text size",
        hintStyle: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 20, color: figmaGrey),
        suffixText: "(in pixels)",
        suffixStyle: TextStyle(color: figmaBlack),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: figmaBlack),
            borderRadius: BorderRadius.circular(5)),
      ),
    ));

    Widget _themes() {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: false,
          title: Text(
            "Theme Selection",
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                            "Encountered new location.Please let uo new profile for this!!!")),
                    Text(
                      "Font Size",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    textSizeInput,
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Theme Color",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ValueListenableBuilder(
                        valueListenable: themeColor,
                        builder: (context, _, __) {
                          return Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(themeColor.value),
                                border: Border.all(color: figmaGrey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: InkWell(
                                  onTap: () {
                                    setTheme();
                                  },
                                  child: Container(
                                    color: Color(themeColor.value),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Current Theme",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  )));
                        }),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Set this as current theme"),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _currentThemeColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size.fromHeight(50)),
                    onPressed: () => onSubmit(),
                    child: Text("SAVE"))
              ],
            ),
          ),
        ),
      );
    }

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
                        Expanded(child: _themes())
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
      return _themes();
  }
}
