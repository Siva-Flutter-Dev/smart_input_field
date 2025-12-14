import 'package:flutter/material.dart';


/// RichEditableText
///
/// Paints RichText on top of a transparent TextField while keeping
/// cursor, selection, IME, and platform behavior intact.
class RichEditableText extends StatelessWidget {
  final List<InlineSpan> spans;
  final TextStyle style;
  final EdgeInsets padding;


  const RichEditableText({
    super.key,
    required this.spans,
    required this.style,
    required this.padding,
  });


  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Padding(
        padding: padding,
        child: RichText(
          text: TextSpan(style: style, children: spans),
        ),
      ),
    );
  }
}