import 'package:flutter/material.dart';

class BottomConteiner extends StatelessWidget {
  Widget child;

  BottomConteiner({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(),
      ),
      child: child,
    );
  }
}