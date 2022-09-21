import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webLayoutScreen;
  final Widget mobileLayoutScreen;

  const ResponsiveLayout(
      {Key? key,
      required this.mobileLayoutScreen,
      required this.webLayoutScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 900) {
        return webLayoutScreen;
      }
      return mobileLayoutScreen;
    });
  }
}
