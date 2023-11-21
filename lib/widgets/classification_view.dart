import 'package:flutter/material.dart';

class ClassificationView extends StatelessWidget {
  double? classification;
  var classificationStyle = TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.amberAccent,
  );

  ClassificationView(this.classification);

  @override
  Widget build(BuildContext context) {
    if (classification == null) return Container();
    return Row(
      children: [
        Text(classification.toString(), style: classificationStyle),
        Icon(Icons.star, color: Colors.amberAccent)
      ],
    );
  }
}