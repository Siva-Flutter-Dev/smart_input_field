import 'package:flutter/material.dart';
import 'link_preview_model.dart';


/// Default UI renderer for link previews.
class LinkPreviewWidget extends StatelessWidget {
  final LinkPreviewData data;


  const LinkPreviewWidget({super.key, required this.data});


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(data.imageUrl!, fit: BoxFit.cover),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.title != null)
                  Text(data.title!, style: Theme.of(context).textTheme.titleMedium),
                if (data.description != null)
                  Text(data.description!, maxLines: 2, overflow: TextOverflow.ellipsis),
                Text(data.domain, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}