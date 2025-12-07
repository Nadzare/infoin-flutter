import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/news_model.dart';

class HistoryService {
  static const String _recentlyViewedKey = 'recently_viewed_news';
  static const int _maxHistoryItems = 20;

  /// Save a news article to recently viewed history
  static Future<void> addToRecentlyViewed(NewsArticle news) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get current history
      final historyList = await getRecentlyViewed();
      
      // Remove if already exists (to avoid duplicates)
      historyList.removeWhere((item) => item.id == news.id);
      
      // Add to beginning of list
      historyList.insert(0, news);
      
      // Keep only last N items
      if (historyList.length > _maxHistoryItems) {
        historyList.removeRange(_maxHistoryItems, historyList.length);
      }
      
      // Convert to JSON and save
      final jsonList = historyList.map((item) => item.toJson()).toList();
      await prefs.setString(_recentlyViewedKey, jsonEncode(jsonList));
      
      print('Added to recently viewed: ${news.title}');
    } catch (e) {
      print('Error adding to recently viewed: $e');
    }
  }

  /// Get recently viewed news articles
  static Future<List<NewsArticle>> getRecentlyViewed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_recentlyViewedKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final List<NewsArticle> newsList = jsonList
          .map((json) => NewsArticle.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return newsList;
    } catch (e) {
      print('Error getting recently viewed: $e');
      return [];
    }
  }

  /// Clear all recently viewed history
  static Future<void> clearRecentlyViewed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_recentlyViewedKey);
      print('Recently viewed history cleared');
    } catch (e) {
      print('Error clearing recently viewed: $e');
    }
  }

  /// Remove a specific item from recently viewed
  static Future<void> removeFromRecentlyViewed(String newsId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyList = await getRecentlyViewed();
      
      historyList.removeWhere((item) => item.id == newsId);
      
      final jsonList = historyList.map((item) => item.toJson()).toList();
      await prefs.setString(_recentlyViewedKey, jsonEncode(jsonList));
      
      print('Removed from recently viewed: $newsId');
    } catch (e) {
      print('Error removing from recently viewed: $e');
    }
  }

  /// Get count of recently viewed items
  static Future<int> getRecentlyViewedCount() async {
    final list = await getRecentlyViewed();
    return list.length;
  }
}
