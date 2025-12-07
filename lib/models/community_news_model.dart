class CommunityNews {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String? imageUrl;
  final String authorName;
  final String authorAvatar;
  final DateTime createdAt;
  final String category;
  final int likesCount;
  final int commentsCount;

  CommunityNews({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.authorName,
    required this.authorAvatar,
    required this.createdAt,
    required this.category,
    this.likesCount = 0,
    this.commentsCount = 0,
  });

  factory CommunityNews.fromJson(Map<String, dynamic> json) {
    return CommunityNews(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      authorName: json['author_name'] ?? 'Anonymous',
      authorAvatar: json['author_avatar'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      category: json['category'] ?? 'Umum',
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'author_name': authorName,
      'author_avatar': authorAvatar,
      'category': category,
      'likes_count': likesCount,
      'comments_count': commentsCount,
    };
  }
}
