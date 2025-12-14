## Smart Input Field (Flutter Package)

### SmartInputField is an all-in-one, rich TextField for Flutter that supports:

* Clickable URLs with link previews

* @Mentions with suggestion overlay

* #Hashtags detection

* Markdown styling (bold, italic, code, strikethrough)

* Debounced link fetching

* Fully platform-adaptive (mobile, web, desktop)

* Designed to be extensible, modular, and future-proof for chat apps, social platforms, and enterprise forms.

## 📦 Installation

Add this to your pubspec.yaml:
```
dependencies:
smart_input_field: ^1.0.0
```

Then run:

`flutter pub get`

## ✨ Features
### 🔗 Link Detection & Preview

#### Detects HTTP / HTTPS URLs in text.

* Clickable links with customizable style.

* Rich link previews with title, description, image, and domain.

* Debounced fetching + caching.

### 🧩 Mentions

#### @mention detection.

* Overlay with autocomplete suggestions.

* Tap to insert mention into the text.

### 🏷 Hashtags

#### #hashtag detection.

* Clickable spans with callback.

### 📝 Markdown & Rich Text

#### Inline markdown rendering:

* **bold**, *italic*, `code`, ~~strikethrough~~

* Works with normal typing and editing.

## 🌐 Platform Adaptive

#### Works on iOS, Android, Web, Windows, macOS, Linux.

#### TextField + RichText overlay for consistent look.

## 🛠 Usage Example
```
import 'package:flutter/material.dart';
import 'package:smart_input_field/smart_input_field.dart';

void main() {
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
home: Scaffold(
appBar: AppBar(title: const Text('Smart Input Field Example')),
body: const ExamplePage(),
),
);
}
}

class ExamplePage extends StatefulWidget {
const ExamplePage({super.key});

@override
State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
final _controller = TextEditingController();
final _focusNode = FocusNode();
String _lastAction = '—';

Future<List<String>> fetchUsers(String query) async {
// Example mention data provider
return ['alice', 'bob', 'charlie'].where((u) => u.startsWith(query)).toList();
}

@override
Widget build(BuildContext context) {
return Padding(
padding: const EdgeInsets.all(16),
child: Column(
children: [
SmartInputField(
controller: _controller,
focusNode: _focusNode,
enableLinks: true,
enableMentions: true,
enableHashtags: true,
enableMarkdown: true,
mentionDataProvider: fetchUsers,
onLinkTap: (url) => setState(() => _lastAction = 'Link tapped: $url'),
onMentionTap: (user) => setState(() => _lastAction = 'Mention tapped: @$user'),
onHashtagTap: (tag) => setState(() => _lastAction = 'Hashtag tapped: #$tag'),
),
const SizedBox(height: 20),
Text('Last interaction: $_lastAction'),
],
),
);
}
}
```
## 🧱 Architecture Overview
```
SmartInputField
├─ PlatformAdaptiveTextField  # Renders TextField + RichText overlay
├─ PatternEngine              # Detects URLs, mentions, hashtags, markdown
├─ LinkPreviewEngine          # Fetches & caches link previews
├─ MentionOverlay             # Suggestion overlay for mentions
└─ Utilities
└─ Debouncer               # Debounced network calls
```
## 🔍 Public API
```
SmartInputField(
controller: controller,
focusNode: focusNode,
enableLinks: true,
enableMentions: true,
enableHashtags: true,
enableMarkdown: true,
mentionDataProvider: (query) async => ['alice', 'bob'],
onLinkTap: (url) {},
onMentionTap: (user) {},
onHashtagTap: (tag) {},
onChanged: (text) {},
);
```
### ⚡ iOS Permissions

#### If you want to fetch real link previews on iOS, ensure you have:
```
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```
## 🔮 Roadmap

* Collaborative editing & mentions

* Inline polls and widgets

* AI-powered suggestions

* Voice-to-text integration

## 📜 License
```
MIT
```