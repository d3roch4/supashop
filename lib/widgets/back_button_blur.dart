import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackButtonBlur extends StatelessWidget {
  Color color;

  BackButtonBlur({this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
        // padding: EdgeInsets.symmetric(vertical: 3),
        decoration: ShapeDecoration(
          color: color.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.50,
              color: Colors.white.withOpacity(0.4000000059604645),
            ),
            borderRadius: BorderRadius.circular(500),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x51000000),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 4,
              sigmaY: 2,
            ),
            child: IconButton(
              onPressed: Get.back,
              icon: Icon(Icons.arrow_back, color: color),
            ),
          ),
        ));
  }
}