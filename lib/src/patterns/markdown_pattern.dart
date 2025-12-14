import 'package:flutter/material.dart';
import '../engine/pattern_engine.dart';
import '../engine/smart_pattern.dart';

class MarkdownPattern extends SmartPattern {
  MarkdownPattern();


  @override
  RegExp get regex => RegExp(r'(\\*\\*[^*]+\\*\\*|`[^`]+`|\\*[^*]+\\*)');


  @override
  TextStyle style(TextStyle base) => base.copyWith(fontWeight: FontWeight.bold);


  @override
  void onTap(String value, PatternEngine engine) {}
}