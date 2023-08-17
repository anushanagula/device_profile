import 'package:device_profiles/blocks/app_bloc.dart';
import 'package:device_profiles/constants.dart';
import 'package:device_profiles/widgets/header_widget.dart';
import 'package:device_profiles/widgets/side_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

const String kCompleteValidHexPattern =
    r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$';
const String kValidHexPattern = r'^#?[0-9a-fA-F]{1,8}';

Color? colorFromHex(String inputString, {bool enableAlpha = true}) {
  // Registers validator for exactly 6 or 8 digits long HEX (with optional #).
  final RegExp hexValidator = RegExp(kCompleteValidHexPattern);
  // Validating input, if it does not match — it's not proper HEX.
  if (!hexValidator.hasMatch(inputString)) return null;
  // Remove optional hash if exists and convert HEX to UPPER CASE.
  String hexToParse = inputString.replaceFirst('#', '').toUpperCase();
  // It may allow HEXs with transparency information even if alpha is disabled,
  if (!enableAlpha && hexToParse.length == 8) {
    // but it will replace this info with 100% non-transparent value (FF).
    hexToParse = 'FF${hexToParse.substring(2)}';
  }
  // HEX may be provided in 3-digits format, let's just duplicate each letter.
  if (hexToParse.length == 3) {
    hexToParse = hexToParse.split('').expand((i) => [i * 2]).join();
  }
  // We will need 8 digits to parse the color, let's add missing digits.
  if (hexToParse.length == 6) hexToParse = 'FF$hexToParse';
  // HEX must be valid now, but as a precaution, it will just "try" to parse it.
  final intColorValue = int.tryParse(hexToParse, radix: 16);
  // If for some reason HEX is not valid — abort the operation, return nothing.
  if (intColorValue == null) return null;
  // Register output color for the last step.
  final color = Color(intColorValue);
  // Decide to return color with transparency information or not.
  return enableAlpha ? color : color.withAlpha(255);
}

String colorToHex(
  Color color, {
  bool includeHashSign = false,
  bool enableAlpha = true,
  bool toUpperCase = true,
}) {
  final String hex = (includeHashSign ? '#' : '') +
      (enableAlpha ? _padRadix(color.alpha) : '') +
      _padRadix(color.red) +
      _padRadix(color.green) +
      _padRadix(color.blue);
  return toUpperCase ? hex.toUpperCase() : hex;
}

// Shorthand for padLeft of RadixString, DRY.
String _padRadix(int value) => value.toRadixString(16).padLeft(2, '0');

final List<List<Color>> _colorTypes = [
  [Colors.red, Colors.redAccent],
  [Colors.pink, Colors.pinkAccent],
  [Colors.purple, Colors.purpleAccent],
  [Colors.deepPurple, Colors.deepPurpleAccent],
  [Colors.indigo, Colors.indigoAccent],
  [Colors.blue, Colors.blueAccent],
  [Colors.lightBlue, Colors.lightBlueAccent],
  [Colors.cyan, Colors.cyanAccent],
  [Colors.teal, Colors.tealAccent],
  [Colors.green, Colors.greenAccent],
  [Colors.lightGreen, Colors.lightGreenAccent],
  [Colors.lime, Colors.limeAccent],
  [Colors.yellow, Colors.yellowAccent],
  [Colors.amber, Colors.amberAccent],
  [Colors.orange, Colors.orangeAccent],
  [Colors.deepOrange, Colors.deepOrangeAccent],
  [Colors.brown],
  [Colors.grey],
  [Colors.blueGrey]
];

List<Color> _shadingTypes(List<Color> colors) {
  List<Color> result = [];

  colors.forEach((Color colorType) {
    if (colorType == Colors.grey) {
      result.addAll([50, 100, 200, 300, 350, 400, 500, 600, 700, 800, 850, 900]
          .map((int shade) {
        return Colors.grey[shade]!;
      }).toList());
    } else if (colorType == Colors.black || colorType == Colors.white) {
    } else if (colorType is MaterialAccentColor) {
      result.addAll([100, 200, 400, 700].map((int shade) {
        return colorType[shade]!;
      }).toList());
    } else if (colorType is MaterialColor) {
      result.addAll(
          [50, 100, 200, 300, 400, 500, 600, 700, 800, 900].map((int shade) {
        return colorType[shade]!;
      }).toList());
    } else {
      result.add(Color(0));
    }
  });

  return result;
}

List<Color> getAllColors() {
  List<Color> res = [];
  _colorTypes.forEach((List<Color> _colors) {
    _shadingTypes(_colors).forEach((Color color) {
      if (color != null) res.add(color);
    });
  });
  return res;
}

class ThemeManager extends StatefulWidget {
  final Color currentColor;
  final Function(int) setThemeColor;
  ThemeManager({required this.currentColor, required this.setThemeColor});
  @override
  _ThemeManagerState createState() => _ThemeManagerState();
}

class _ThemeManagerState extends State<ThemeManager> {
  Color? selectedColor;
  double? selectedTextSize;
  bool isLoading = false;
  AppBloc? appBloc;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  ScrollController sc = ScrollController();
  double maxWidth = 600;
  late String hexCode;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.currentColor;
    hexCode = colorToHex(selectedColor!, includeHashSign: false);
  }

  @override
  Widget build(BuildContext context) {
    appBloc ??= Provider.of<AppBloc>(context, listen: true);

    Widget currentTheme = Container(
      alignment: Alignment.center,
      height: 50,
      padding: EdgeInsets.all(buildingForWebDesktop(context) ? 15 : 10),
      width: buildingForWebDesktop(context)
          ? maxWidth
          : MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [selectedColor!, selectedColor!]),
          borderRadius: BorderRadius.circular(5)),
      child: Text(
        "Selected Theme",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );

    Widget colors = Scrollbar(
      controller: sc,
      child: GridView.count(
        controller: sc,
        crossAxisCount: buildingForWebDesktop(context) ? 10 : 6,
        children: getAllColors()
            .map((color) => InkWell(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  child: selectedColor == color
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : null,
                  margin: EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                )))
            .toList(),
      ),
    );

    return Center(
      child: Container(
        width: maxWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Choose Theme Color"),
              InkWell(
                child: Icon(Icons.close),
                onTap: () => Navigator.pop(context),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: currentTheme,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: colors,
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 5, horizontal: 30)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(figmaOrange)),
                  onPressed: () => widget.setThemeColor(selectedColor!.value),
                  child: Text("Apply")),
              SizedBox(
                width: 20,
              ),
              TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          )
        ]),
      ),
    );
  }

  setTheme() async {
    /*if (selectedColor == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please select a color')));
      return;
    }
    setState(() {
      isLoading = true;
    });
    var x = await appBloc!.setTheme(selectedColor!);
    if (x["success"] == true)
      Store.appTheme.colors = [selectedColor!, selectedColor!];
    setState(() {
      isLoading = false;
    });*/
  }
}
