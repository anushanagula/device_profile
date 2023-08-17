import 'package:device_profiles/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatelessWidget {
  final ValueNotifier<int> currentPage;
  BottomNav({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: currentPage,
        builder: (_, int pageNo, __) {
          return Container(
            height: kBottomNavigationBarHeight,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey[400]!,
                offset: Offset(0, -1),
                blurRadius: 4,
              )
            ]),
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (pageNo != 0) {
                        currentPage.value = 0;
                      }
                    },
                    child: _Item(
                      active: pageNo == 0,
                      title: "Dashboard",
                      icon: Icon(Icons.assessment_outlined,
                          color: Color(0xff7c7c7c)),
                      activeIcon: Icon(
                        Icons.assessment,
                        color: figmaOrange,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (pageNo != 1) {
                        currentPage.value = 1;
                      }
                    },
                    child: _Item(
                      active: pageNo == 1,
                      title: "Themes",
                      icon: Icon(Icons.shopping_cart_outlined,
                          color: Color(0xff7c7c7c)),
                      activeIcon: Icon(
                        Icons.shopping_cart,
                        color: figmaOrange,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (pageNo != 2) {
                        currentPage.value = 2;
                      }
                    },
                    child: _Item(
                      active: pageNo == 2,
                      title: "About",
                      icon: Icon(Icons.contact_support_outlined,
                          color: Color(0xff7c7c7c)),
                      activeIcon: Icon(
                        Icons.contact_support,
                        color: figmaOrange,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _Item extends StatelessWidget {
  final String title;
  final bool active;
  final Widget icon;
  final Widget activeIcon;
  _Item(
      {required this.title,
      required this.active,
      required this.icon,
      required this.activeIcon});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: active ? activeIcon : icon,
                margin: EdgeInsets.only(top: 10),
              ),
              SizedBox(
                height: 3,
              ),
              Text(title,
                  style: TextStyle(
                      fontSize: 10, color: active ? figmaOrange : Colors.grey))
            ],
          ),
        ),
        if (active)
          Positioned(
            child: Container(
              height: 17,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: figmaOrange),
            ),
            top: -12,
            left: 0,
            right: 0,
          )
      ],
    );
  }
}
