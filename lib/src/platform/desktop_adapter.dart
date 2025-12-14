import 'package:flutter/material.dart';


/// Desktop adaptive behaviors (mouse hover, padding).
class DesktopAdaptiveLayer extends StatelessWidget {
  final Widget child;


  const DesktopAdaptiveLayer({super.key, required this.child});


  @override
  Widget build(BuildContext context) {
    return MouseRegion(cursor: SystemMouseCursors.text, child: child);
  }
}