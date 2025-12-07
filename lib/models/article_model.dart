class Article {
  final String title;
  final String link;
  final String imageUrl;
  final String sourceId;
  final String pubDate;
  final String? description;
  final String? content;

  Article({
    required this.title,
    required this.link,
    required this.imageUrl,
    required this.sourceId,
    required this.pubDate,
    this.description,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      link: json['link'] ?? '',
      imageUrl: json['image_url'] ?? 'https://placehold.co/600x400?text=No+Image',
      sourceId: json['source_id'] ?? 'Unknown Source',
      pubDate: json['pubDate'] ?? '',
      description: json['description'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'image_url': imageUrl,
      'source_id': sourceId,
      'pubDate': pubDate,
      'description': description,
      'content': content,
    };
  }
}
