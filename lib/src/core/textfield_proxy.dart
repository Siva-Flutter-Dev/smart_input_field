import 'package:flutter/material.dart';


/// Proxy that wraps native TextField without breaking behavior.
class TextFieldProxy extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextStyle style;


  const TextFieldProxy({
    super.key,
    required this.controller,
    this.focusNode,
    this.decoration,
    required this.style,
  });


  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: decoration,
      style: style.copyWith(color: Colors.transparent),
      cursorColor: style.color,
      enableInteractiveSelection: true,
    );
  }
}