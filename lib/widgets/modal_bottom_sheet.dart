import 'package:flutter/material.dart';
import 'package:supashop/util/util.dart';

class ModalBottomSheet extends StatelessWidget {
  const ModalBottomSheet({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
  });

  final String title;
  final Widget content;
  final List<Widget> actions;

  static void show({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget> actions = const [],
  }) =>
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        builder: (context) => ModalBottomSheet(
          title: title,
          content: content,
          actions: actions,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          width: 40,
          height: 4,
          margin: EdgeInsets.symmetric(vertical: kPaddingInternal),
        ),
        Text(title),
        const SizedBox(height: 16),
        content,
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: actions,
        ),
      ],
    );
  }
}