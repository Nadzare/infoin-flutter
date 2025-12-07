import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/community_news_model.dart';
import '../models/comment_model.dart';

class CommunityNewsService {
  static final _supabase = Supabase.instance.client;

  /// Fetch all community news ordered by newest first
  static Future<List<CommunityNews>> fetchCommunityNews() async {
    try {
      final response = await _supabase
          .from('community_news')
          .select()
          .order('created_at', ascending: false);

      final List<CommunityNews> newsList = [];
      for (var item in response) {
        newsList.add(CommunityNews.fromJson(item));
      }

      return newsList;
    } catch (e) {
      print('Error fetching community news: $e');
      rethrow;
    }
  }

  /// Create new community news post
  static Future<void> createCommunityNews({
    required String title,
    required String content,
    required String category,
    String? imageUrl,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Get user profile for author info
      String authorName = user.email?.split('@')[0] ?? 'Anonymous';
      String authorAvatar = '';

      try {
        final profileResponse = await _supabase
            .from('profiles')
            .select('full_name, avatar_url')
            .eq('id', user.id)
            .maybeSingle();

        if (profileResponse != null) {
          authorName = profileResponse['full_name'] ?? authorName;
          authorAvatar = profileResponse['avatar_url'] ?? '';
        }
      } catch (e) {
        print('Profile not found, using default values: $e');
      }

      // Insert community news
      await _supabase.from('community_news').insert({
        'user_id': user.id,
        'title': title,
        'content': content,
        'category': category,
        'image_url': imageUrl,
        'author_name': authorName,
        'author_avatar': authorAvatar,
        'likes_count': 0,
        'comments_count': 0,
      });

      print('Community news created successfully');
    } catch (e) {
      print('Error creating community news: $e');
      rethrow;
    }
  }

  /// Delete community news (only by author)
  static Future<void> deleteCommunityNews(String newsId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _supabase
          .from('community_news')
          .delete()
          .eq('id', newsId)
          .eq('user_id', user.id);

      print('Community news deleted successfully');
    } catch (e) {
      print('Error deleting community news: $e');
      rethrow;
    }
  }

  /// Like/Unlike community news
  static Future<void> toggleLike(String newsId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Check if already liked
      final existingLike = await _supabase
          .from('news_likes')
          .select()
          .eq('news_id', newsId)
          .eq('user_id', user.id)
          .maybeSingle();

      if (existingLike != null) {
        // Unlike
        await _supabase
            .from('news_likes')
            .delete()
            .eq('news_id', newsId)
            .eq('user_id', user.id);

        // Decrement likes count
        await _supabase.rpc('decrement_likes', params: {'news_id': newsId});
      } else {
        // Like
        await _supabase.from('news_likes').insert({
          'news_id': newsId,
          'user_id': user.id,
        });

        // Increment likes count
        await _supabase.rpc('increment_likes', params: {'news_id': newsId});
      }

      print('Like toggled successfully');
    } catch (e) {
      print('Error toggling like: $e');
      rethrow;
    }
  }

  /// Check if user has liked the news
  static Future<bool> checkIfLiked(String newsId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final result = await _supabase
          .from('news_likes')
          .select()
          .eq('news_id', newsId)
          .eq('user_id', user.id)
          .maybeSingle();

      return result != null;
    } catch (e) {
      print('Error checking like status: $e');
      return false;
    }
  }

  /// Fetch comments for a news
  static Future<List<Comment>> fetchComments(String newsId) async {
    try {
      final response = await _supabase
          .from('news_comments')
          .select()
          .eq('news_id', newsId)
          .order('created_at', ascending: false);

      final List<Comment> comments = [];
      for (var item in response) {
        comments.add(Comment.fromJson(item));
      }

      return comments;
    } catch (e) {
      print('Error fetching comments: $e');
      rethrow;
    }
  }

  /// Add comment to news
  static Future<void> addComment(String newsId, String content) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Get author name
      String authorName = user.email?.split('@')[0] ?? 'Anonymous';

      try {
        final profileResponse = await _supabase
            .from('profiles')
            .select('full_name')
            .eq('id', user.id)
            .maybeSingle();

        if (profileResponse != null) {
          authorName = profileResponse['full_name'] ?? authorName;
        }
      } catch (e) {
        print('Profile not found, using default name: $e');
      }

      // Insert comment
      await _supabase.from('news_comments').insert({
        'news_id': newsId,
        'user_id': user.id,
        'author_name': authorName,
        'content': content,
      });

      // Increment comments count
      final current = await _supabase
          .from('community_news')
          .select('comments_count')
          .eq('id', newsId)
          .single();

      await _supabase
          .from('community_news')
          .update({'comments_count': (current['comments_count'] ?? 0) + 1})
          .eq('id', newsId);

      print('Comment added successfully');
    } catch (e) {
      print('Error adding comment: $e');
      rethrow;
    }
  }
}
