import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LogoApp extends StatelessWidget {
  bool darkMode = Get.isDarkMode;
  double width;
  bool hero;

  LogoApp({bool? darkMode, this.width = 150, this.hero = true}) {
    this.darkMode = darkMode ?? this.darkMode;
  }

  @override
  Widget build(BuildContext context) {
    var icon = SvgPicture.asset('images/logo-large.svg',
        width: width,
        //colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
        semanticsLabel: 'logo app');
    if (hero != true) return icon;
    return Hero(tag: 'logo-app', child: icon);
  }
}