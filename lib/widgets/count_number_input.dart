import 'package:flutter/material.dart';

class CountNumberInput extends StatelessWidget {
  int value;
  int min;
  int? max;
  bool compactIfZero;
  ValueChanged<int>? onChanged;
  double iconSize;
  EdgeInsetsGeometry? padding;
  Icon? iconIfOne;

  CountNumberInput({
    this.value = 0,
    this.min = 0,
    this.max,
    this.compactIfZero = false,
    this.onChanged,
    this.iconSize = 18,
    this.padding = const EdgeInsets.all(8),
    this.iconIfOne,
  });

  @override
  Widget build(BuildContext context) {
    var boxConstraints = BoxConstraints(
      minWidth: iconSize,
      maxWidth: iconSize,
      minHeight: iconSize,
      maxHeight: iconSize,
    );
    var addButton = IconButton(
        constraints: boxConstraints,
        onPressed: max != null && value >= max! ? null : add,
        // padding: EdgeInsets.zero,
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            fixedSize: MaterialStateProperty.all(Size(iconSize, iconSize))),
        iconSize: iconSize,
        icon: Icon(Icons.add));
    if (compactIfZero && value == 0) return addButton;
    return Container(
      padding: padding,
      decoration: ShapeDecoration(
        // color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              constraints: boxConstraints,
              onPressed: () => add(-1),
              padding: EdgeInsets.zero,
              iconSize: iconSize,
              icon: iconIfOne != null && value == 1
                  ? iconIfOne!
                  : Icon(Icons.remove)),
          const SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(minWidth: 20),
            child: Text(
              '${value}',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          addButton,
        ],
      ),
    );
  }

  void add([int i = 1]) {
    value += i;
    if (value < min) value = min;
    if (max != null && value > max!) value = max!;
    if (onChanged != null) onChanged!(value);
  }
}