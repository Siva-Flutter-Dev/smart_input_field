import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../utils/debounce.dart';
import 'link_preview_model.dart';


/// Fetches and caches link preview metadata.
///
/// Networking layer intentionally abstracted to keep this engine
/// platform-safe (web, mobile, desktop).
class LinkPreviewEngine {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  final Map<String, LinkPreviewData> _cache = {};


  /// Fetch preview for a given URL.
  void fetch(
      String url, {
        required Future<LinkPreviewData> Function(String url) loader,
        required ValueChanged<LinkPreviewData> onResult,
      }) {
    if (_cache.containsKey(url)) {
      onResult(_cache[url]!);
      return;
    }


    _debouncer.run(() async {
      final data = await loader(url);
      _cache[url] = data;
      onResult(data);
    });
  }
}