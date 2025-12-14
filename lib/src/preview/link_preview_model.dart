/// Represents extracted metadata from a URL.
class LinkPreviewData {
  final String url;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String domain;


  const LinkPreviewData({
    required this.url,
    required this.domain,
    this.title,
    this.description,
    this.imageUrl,
  });
}