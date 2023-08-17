import 'package:device_profiles/blocks/app_bloc.dart';
import 'package:device_profiles/constants.dart';
import 'package:device_profiles/widgets/location_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dotted_border/dotted_border.dart';

class LocationSetUpDialog extends StatefulWidget {
  LocationSetUpDialog({Key? key}) : super(key: key);

  @override
  State<LocationSetUpDialog> createState() => _LocationSetUpDialogState();
}

class _LocationSetUpDialogState extends State<LocationSetUpDialog>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = buildingForWebDesktop(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(),
        ),
        Container(
          width: 600,
          alignment: Alignment.center,
          margin: isDesktop ? null : EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: isDesktop
                    ? const EdgeInsets.all(40)
                    : const EdgeInsets.fromLTRB(10, 40, 10, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                              color: figmaGreen,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 15),
                        Icon(
                          Icons.back_hand,
                          size: 20,
                          color: figmaGreen,
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Get started with adding location",
                      style: TextStyle(
                          fontSize: isDesktop ? 18 : 16,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Padding(
                  padding: isDesktop
                      ? const EdgeInsets.symmetric(horizontal: 40)
                      : const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: _ProgressWidget(currentStep: 2)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DottedBorder(
                      padding: EdgeInsets.all(0),
                      color: figmaBlue,
                      child: Container(
                        width: double.infinity,
                        color: figmaLightBlue,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Thats it you are all set ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: figmaBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: SizedBox(),
        ),
      ],
    );
  }
}

class _ProgressWidget extends StatelessWidget {
  final int currentStep;
  _ProgressWidget({this.currentStep = 2, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDesktop = buildingForWebDesktop(context);
    return CustomPaint(
      foregroundPainter: _ProgressBarPainter(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            height: 100,
            alignment: Alignment.center,
            child: Row(
              children: [
                SizedBox(width: 60),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Create Your Own Themes",
                        style: TextStyle(
                            fontSize: 16,
                            color: figmaGreen,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Just 1 step away ",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffcaffd8)),
            child: Row(
              children: [
                SizedBox(width: 70),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Add Location",
                        style: TextStyle(
                            fontSize: 22,
                            color: figmaBlack,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Add lat and long",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: isDesktop ? null : 40,
                  width: isDesktop ? null : 40,
                  margin: isDesktop ? null : EdgeInsets.only(right: 10),
                  child: AvatarGlow(
                      showTwoGlows: true,
                      glowColor: figmaGreen,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        LocationScreen()));
                          },
                          child: Container(
                            height: isDesktop ? 60 : 40,
                            width: isDesktop ? 60 : 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: figmaGreen),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      endRadius: 60),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            height: 90,
            alignment: Alignment.center,
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Set Your favourite theme",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Yu can set your fav theme",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[350]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  final int currentStep;
  _ProgressBarPainter({this.currentStep = 2});

  @override
  void paint(Canvas canvas, Size size) {
    var greenPaint = Paint()..color = figmaGreen;
    var greyPaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    var whitePaint = Paint()..color = Colors.white;
    canvas.drawLine(
        Offset(40, 50), Offset(40, 155), greenPaint..strokeWidth = 2);
    if (currentStep == 3)
      canvas.drawLine(
          Offset(40, 155), Offset(40, 260), greenPaint..strokeWidth = 2);
    else
      drawVerticalLine(canvas, greenPaint..strokeWidth = 2, Offset(40, 155),
          Offset(40, 260), 4, 4);

    canvas.drawCircle(Offset(40, 50), 12, greenPaint);
    canvas.drawLine(
        Offset(34, 50),
        Offset(38, 55),
        whitePaint
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round);
    canvas.drawLine(
        Offset(38, 55),
        Offset(47, 46),
        whitePaint
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round);

    if (currentStep == 3) {
      canvas.drawCircle(Offset(40, 155), 12, greenPaint);
      canvas.drawLine(
          Offset(34, 155),
          Offset(38, 160),
          whitePaint
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round);
      canvas.drawLine(
          Offset(38, 160),
          Offset(47, 151),
          whitePaint
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round);
    } else {
      TextSpan span2 = TextSpan(
          text: "2",
          style: TextStyle(
            color: figmaGreen,
            fontSize: 20,
            package: Icons.check_circle.fontPackage,
          ));
      TextPainter tp2 = TextPainter(
          text: span2,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center);
      tp2.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      tp2.layout();
      greenPaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(40, 155), 15, whitePaint);
      canvas.drawCircle(Offset(40, 155), 15, greenPaint);
      tp2.paint(canvas, Offset(34, 143));
    }

    if (currentStep == 3) {
      TextSpan span2 = TextSpan(
          text: "3",
          style: TextStyle(
            color: figmaGreen,
            fontSize: 20,
            package: Icons.check_circle.fontPackage,
          ));
      TextPainter tp2 = TextPainter(
          text: span2,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center);
      tp2.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      tp2.layout();
      greenPaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(40, 260), 15, whitePaint);
      canvas.drawCircle(Offset(40, 260), 15, greenPaint);
      tp2.paint(canvas, Offset(34, 247));
    } else {
      TextSpan span3 = TextSpan(
          text: "3",
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
            package: Icons.check_circle.fontPackage,
          ));
      TextPainter tp3 = TextPainter(
          text: span3,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center);
      tp3.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      tp3.layout();
      canvas.drawCircle(Offset(40, 260), 12, whitePaint);
      canvas.drawCircle(Offset(40, 260), 12, greyPaint);
      tp3.paint(canvas, Offset(37, 253));
    }
  }

  void drawVerticalLine(Canvas canvas, Paint paint, Offset p1, Offset p2,
      double dashWidth, double spaceWidth) {
    double startY = p1.dy;
    final space = (spaceWidth + dashWidth);
    while (startY < p2.dy) {
      canvas.drawLine(
          Offset(p1.dx, startY), Offset(p1.dx, startY + dashWidth), paint);
      startY += space;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
