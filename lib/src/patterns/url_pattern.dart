import 'package:flutter/material.dart';
import '../engine/pattern_engine.dart';
import '../engine/smart_pattern.dart';

class UrlPattern extends SmartPattern {
   UrlPattern();


  @override
  RegExp get regex => RegExp(r'((https?://)|(www\.))[\w\-._~:/?#[\]@!$&()*+,;=%]+');


  @override
  TextStyle style(TextStyle base) => base.copyWith(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );


  @override
  void onTap(String value, PatternEngine engine) {
    engine.onLinkTap?.call(value);
  }
}
