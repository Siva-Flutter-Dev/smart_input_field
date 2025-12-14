import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'smart_pattern.dart';


/// Builds RichText spans based on registered patterns.
class PatternEngine {
  final List<SmartPattern> _patterns = [];


  final ValueChanged<String>? onLinkTap;
  final ValueChanged<String>? onMentionTap;
  final ValueChanged<String>? onHashtagTap;


  PatternEngine({this.onLinkTap, this.onMentionTap, this.onHashtagTap});


  /// Registers a new pattern.
  void register(SmartPattern pattern) => _patterns.add(pattern);


  /// Builds inline spans from raw text.
  List<InlineSpan> build(String text, TextStyle baseStyle) {
    final spans = <InlineSpan>[];
    int index = 0;

    while (index < text.length) {
      Match? earliestMatch;
      SmartPattern? matched;

      for (final p in _patterns) {
        final m = p.regex.firstMatch(text.substring(index));
        if (m != null) {
          if (earliestMatch == null || m.start < earliestMatch.start) {
            earliestMatch = m;
            matched = p;
          }
        }
      }

      if (earliestMatch == null || matched == null) {
        spans.add(TextSpan(
          text: text.substring(index),
          style: baseStyle,
        ));
        break;
      }

      if (earliestMatch.start > 0) {
        spans.add(TextSpan(
          text: text.substring(index, index + earliestMatch.start),
          style: baseStyle,
        ));
      }

      final value = earliestMatch.group(0)!;

      spans.add(TextSpan(
        text: value,
        style: matched.style(baseStyle),
        recognizer: TapGestureRecognizer()
          ..onTap = () => matched?.onTap(value, this),
      ));

      index += earliestMatch.start + value.length;
    }

    return spans;
  }
}