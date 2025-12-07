class NewsSource {
  final String id;
  final String name;
  final String logoUrl;
  final String type; // 'global' or 'local'
  bool isSelected;

  NewsSource({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.type,
    this.isSelected = false,
  });
}
