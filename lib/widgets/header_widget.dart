import 'package:device_profiles/constants.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
        shadowColor: bgColor,
        elevation: 2,
        color: Colors.white,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wallet_travel),
                      SizedBox(width: 12),
                      Text(
                        "My Store",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  Text("Good Morning")
                ])));
  }
}
