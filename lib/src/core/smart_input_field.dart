import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../engine/pattern_engine.dart';
import '../overlay/mention_overlay.dart';
import '../patterns/hashtag_pattern.dart';
import '../patterns/markdown_pattern.dart';
import '../patterns/mention_pattern.dart';
import '../patterns/url_pattern.dart';
import '../platform/platform_adaptive.dart';
import '../preview/link_preview_engine.dart';
import '../preview/link_preview_model.dart';

class SmartInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextStyle? style;

  final bool enableLinks;
  final bool enableMentions;
  final bool enableHashtags;
  final bool enableMarkdown;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onLinkTap;
  final ValueChanged<String>? onMentionTap;
  final ValueChanged<String>? onHashtagTap;

  final Future<List<String>> Function(String)? mentionDataProvider;

  const SmartInputField({
    super.key,
    required this.controller,
    this.focusNode,
    this.decoration,
    this.style,
    this.enableLinks = true,
    this.enableMentions = true,
    this.enableHashtags = true,
    this.enableMarkdown = true,
    this.onChanged,
    this.onLinkTap,
    this.onMentionTap,
    this.onHashtagTap,
    this.mentionDataProvider,
  });

  @override
  State<SmartInputField> createState() => _SmartInputFieldState();
}

class _SmartInputFieldState extends State<SmartInputField> {
  late final PatternEngine _engine;
  final LinkPreviewEngine _linkPreviewEngine = LinkPreviewEngine();
  LinkPreviewData? _currentPreview;

  OverlayEntry? _mentionOverlay;

  @override
  void initState() {
    super.initState();

    _engine = PatternEngine(
      onLinkTap: widget.onLinkTap,
      onMentionTap: _onMentionTapped,
      onHashtagTap: widget.onHashtagTap,
    );

    if (widget.enableLinks) _engine.register(UrlPattern());
    if (widget.enableMentions) _engine.register(MentionPattern());
    if (widget.enableHashtags) _engine.register(HashtagPattern());
    if (widget.enableMarkdown) _engine.register(MarkdownPattern());

    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    widget.onChanged?.call(widget.controller.text);
    _updateMentionOverlay();
    _updateLinkPreview();
    setState(() {});
  }

  void _onMentionTapped(String mention) {
    widget.onMentionTap?.call(mention);
  }

  void _updateMentionOverlay() async {
    if (!widget.enableMentions || widget.mentionDataProvider == null) return;

    final cursorPos = widget.controller.selection.baseOffset;
    final text = widget.controller.text;
    final mentionMatch = RegExp(r'@\w+$').firstMatch(text.substring(0, cursorPos));

    if (mentionMatch != null) {
      final query = mentionMatch.group(0)!.substring(1); // remove @
      final suggestions = await widget.mentionDataProvider!(query);

      _showMentionOverlay(suggestions);
    } else {
      _removeMentionOverlay();
    }
  }

  void _showMentionOverlay(List<String> suggestions) {
    _removeMentionOverlay();

    final overlay = OverlayEntry(
      builder: (context) {
        final renderBox = context.findRenderObject() as RenderBox?;
        final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

        return Positioned(
          left: offset.dx + 16, // padding offset
          top: offset.dy + 50, // roughly below TextField
          right: 16,
          child: MentionOverlay(
            suggestions: suggestions,
            onSelect: (user) {
              _insertMention(user);
              _removeMentionOverlay();
            },
          ),
        );
      },
    );

    Overlay.of(context).insert(overlay);
    _mentionOverlay = overlay;
  }

  void _removeMentionOverlay() {
    _mentionOverlay?.remove();
    _mentionOverlay = null;
  }

  void _insertMention(String user) {
    final cursorPos = widget.controller.selection.baseOffset;
    final text = widget.controller.text;
    final start = text.substring(0, cursorPos).lastIndexOf('@');
    final end = cursorPos;
    final newText = text.replaceRange(start, end, '@$user ');
    widget.controller.value = widget.controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: start + user.length + 2),
    );
  }

  Future<LinkPreviewData> fetchOG(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) throw Exception('Failed to fetch $url');
    final html = response.body;

    final title = RegExp(r'<meta property="og:title" content="([^"]+)"')
        .firstMatch(html)?.group(1);
    final description = RegExp(r'<meta property="og:description" content="([^"]+)"')
        .firstMatch(html)?.group(1);
    final image = RegExp(r'<meta property="og:image" content="([^"]+)"')
        .firstMatch(html)?.group(1);

    final domain = Uri.tryParse(url)?.host ?? '';

    return LinkPreviewData(
      url: url,
      title: title,
      description: description,
      imageUrl: image,
      domain: domain,
    );
  }


  void _updateLinkPreview() {
    if (!widget.enableLinks) return;

    final urlMatch = RegExp(r'(https?://\S+)').firstMatch(widget.controller.text);
    if (urlMatch != null) {
      final url = urlMatch.group(0)!;

      _linkPreviewEngine.fetch(
        url,
        loader: fetchOG,
        onResult: (data) {
          print("=========");
          print(data.imageUrl);
          print(data.title);
          setState(() => _currentPreview = data);
        },
      );
    } else {
      setState(() => _currentPreview = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? DefaultTextStyle.of(context).style;

    return Column(
      children: [
        if (_currentPreview != null)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                if (_currentPreview?.imageUrl != null)
                  Image.network(
                    _currentPreview!.imageUrl??'',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_currentPreview?.title ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (_currentPreview?.description != null)
                        Text(_currentPreview?.description??'',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12)),
                      Text(
                        _currentPreview?.url??'',
                        style: const TextStyle(fontSize: 10, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        PlatformAdaptiveTextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          decoration: widget.decoration,
          style: style,
          spans: _engine.build(widget.controller.text, style),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _removeMentionOverlay();
    super.dispose();
  }
}
