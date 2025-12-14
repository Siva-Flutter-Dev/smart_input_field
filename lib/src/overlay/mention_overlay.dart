import 'package:flutter/material.dart';


/// Overlay that displays mention suggestions anchored to cursor.
class MentionOverlay extends StatefulWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSelect;


  const MentionOverlay({
    super.key,
    required this.suggestions,
    required this.onSelect,
  });


  @override
  State<MentionOverlay> createState() => _MentionOverlayState();
}


class _MentionOverlayState extends State<MentionOverlay> {
  int index = 0;


  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.suggestions.length,
        itemBuilder: (context, i) {
          final selected = i == index;
          return InkWell(
            onTap: () => widget.onSelect(widget.suggestions[i]),
            child: Container(
              color: selected ? Theme.of(context).highlightColor : null,
              padding: const EdgeInsets.all(12),
              child: Text(widget.suggestions[i]),
            ),
          );
        },
      ),
    );
  }
}