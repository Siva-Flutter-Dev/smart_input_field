import 'package:flutter/material.dart';

import '../engine/pattern_engine.dart';
import '../engine/smart_pattern.dart';

class HashtagPattern extends SmartPattern {
   HashtagPattern();


  @override
  RegExp get regex => RegExp(r'#\\w+');


  @override
  TextStyle style(TextStyle base) => base.copyWith(color: Colors.teal);


  @override
  void onTap(String value, PatternEngine engine) {
    engine.onHashtagTap?.call(value.substring(1));
  }
}