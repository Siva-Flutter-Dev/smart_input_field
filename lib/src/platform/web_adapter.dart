import 'package:flutter/material.dart';


/// Web specific adaptive behavior (selection, cursor, IME).
class WebAdaptiveLayer extends StatelessWidget {
  final Widget child;


  const WebAdaptiveLayer({super.key, required this.child});


  @override
  Widget build(BuildContext context) {
    return SelectionArea(child: child);
  }
}