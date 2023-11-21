import 'package:flutter/material.dart';

class AdptiveScaffold extends StatelessWidget {
  WidgetBuilder body;
  List<NavigationDestination> destinations;
  int selectedIndex;
  final Function(int) onSelectedIndexChange;

  AdptiveScaffold({
    required this.body,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelectedIndexChange,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 800) return buildDesktop(context);
      return buildMobile(context);
    });
  }

  Widget buildMobile(BuildContext context) {
    return Scaffold(
      body: body(context),
      bottomNavigationBar: Row(children: [
        for (var i = 0; i < destinations.length; i++)
          InkWell(
            onTap: () => onSelectedIndexChange(i),
            child: destinations[i],
          )
      ]),
    );
  }

  Widget buildDesktop(BuildContext context) {
    return Row(children: []);
  }
}