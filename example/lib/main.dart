import 'package:flutter/material.dart';
import 'package:smart_input_field/smart_input_field.dart';

void main() {
  runApp(const OmniExampleApp());
}

class OmniExampleApp extends StatelessWidget {
  const OmniExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Omni Smart TextField Example',
      theme: ThemeData(useMaterial3: true),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  String _lastAction = '—';

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Omni Smart TextField')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmartInputField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                hintText: 'Type a URL, @mention or #hashtag…',
                border: OutlineInputBorder(),
              ),
              enableLinks: true,
              enableMentions: true,
              enableHashtags: true,
              enableMarkdown: true,
              onChanged: (v){
                setState(() {
                  print(v);
                  print('Last : $_lastAction');
                });
              },
              onLinkTap: (url) {
                setState(() => _lastAction = 'Link tapped: $url');
              },
              onMentionTap: (user) {
                setState(() => _lastAction = 'Mention tapped: @$user');
              },
              onHashtagTap: (tag) {
                setState(() => _lastAction = 'Hashtag tapped: #$tag');
              },
            ),
            const SizedBox(height: 24),
            const Text('Last interaction:'),
            const SizedBox(height: 8),
            Text(
              _lastAction,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            Text(
              'Try typing:\n• https://flutter.dev\n• @alice\n• #flutter',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
