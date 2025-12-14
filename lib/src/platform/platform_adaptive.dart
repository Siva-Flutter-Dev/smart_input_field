import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformAdaptiveTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextStyle style;
  final List<InlineSpan> spans;

  const PlatformAdaptiveTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.decoration,
    required this.style,
    required this.spans,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux);

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // 1️⃣ EditableText for input, selection, and cursor
        TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: decoration,
          style: style.copyWith(color: Colors.transparent),
          cursorColor: style.color,
          enableInteractiveSelection: true,
        ),

        // 2️⃣ RichText overlay for visible styled spans and tappable links
        Padding(
          padding: isDesktop
              ? const EdgeInsets.all(14)
              : const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: RichText(
            text: TextSpan(style: style, children: spans),
          ),
        ),
      ],
    );
  }
}