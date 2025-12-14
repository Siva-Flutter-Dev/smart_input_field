import 'package:flutter/material.dart';
import 'package:smart_input_field/src/engine/pattern_engine.dart';


/// Base contract for all smart patterns.
abstract class SmartPattern {
  /// Regular expression used to detect the pattern.
  RegExp get regex;


  /// Style applied when pattern is matched.
  TextStyle style(TextStyle base);


  /// Tap handler for matched value.
  void onTap(String value, PatternEngine engine);
}