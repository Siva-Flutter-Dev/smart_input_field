import 'package:flutter/material.dart';
import '../engine/pattern_engine.dart';
import '../engine/smart_pattern.dart';

class MentionPattern extends SmartPattern {
   MentionPattern();


  @override
  RegExp get regex => RegExp(r'@\\w+');


  @override
  TextStyle style(TextStyle base) => base.copyWith(color: Colors.deepPurple);


  @override
  void onTap(String value, PatternEngine engine) {
    engine.onMentionTap?.call(value.substring(1));
  }
}