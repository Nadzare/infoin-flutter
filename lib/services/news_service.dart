import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class NewsService {
  static const String _baseUrl = 'https://newsdata.io/api/1/news';
  static const String _apiKey = 'pub_5361dff2fd6a413dbe02325a647d9da2';

  /// Fetch news from NewsData.io API
  /// 
  /// [countryCode] - Country code (default: 'id' for Indonesia)
  /// [category] - News category (optional): business, entertainment, 
  ///              environment, food, health, politics, science, sports, 
  ///              technology, top, tourism, world
  /// [language] - Language code (optional, default: based on country)
  /// [pageSize] - Number of articles to fetch (optional, max depends on API plan)
  static Future<List<Article>> fetchNews(
    String? countryCode, {
    String? category,
    String? language,
    int? pageSize,
  }) async {
    try {
      // Use 'id' as default if countryCode is null
      final country = countryCode ?? 'id';
      
      // Build query parameters
      final queryParams = {
        'apikey': _apiKey,
        'country': country,
        if (category != null && category.isNotEmpty) 'category': category,
        if (language != null && language.isNotEmpty) 'language': language,
        // Note: 'size' parameter might not be supported in free plan
      };

      // Build URL with query parameters
      final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParams);

      print('Fetching news from: $uri');

      // Make HTTP GET request
      final response = await http.get(uri);

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Check if the response contains results
        if (jsonData['status'] == 'success' && jsonData['results'] != null) {
          final List<dynamic> results = jsonData['results'];
          
          // Convert JSON array to List<Article>
          final articles = results
              .map((json) => Article.fromJson(json as Map<String, dynamic>))
              .toList();

          print('Successfully fetched ${articles.length} articles');
          return articles;
        } else {
          // API returned error
          final errorMessage = jsonData['message'] ?? 'Unknown error';
          throw Exception('API Error: $errorMessage');
        }
      } else {
        // HTTP error
        throw Exception(
          'Failed to load news. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching news: $e');
      rethrow;
    }
  }

  /// Fetch news by specific category
  static Future<List<Article>> fetchNewsByCategory(
    String category, {
    String? countryCode,
    int? pageSize,
  }) async {
    return fetchNews(countryCode, category: category, pageSize: pageSize);
  }

  /// Fetch top headlines (no category filter)
  static Future<List<Article>> fetchTopHeadlines({
    String? countryCode,
    int? pageSize,
  }) async {
    return fetchNews(countryCode, pageSize: pageSize);
  }

  /// Fetch mixed news from multiple categories
  /// This fetches articles from all categories and mixes them
  /// [priorityCategory] - Category to fetch more articles from (2x more)
  static Future<List<Article>> fetchMixedNews(
    String? countryCode, {
    String? priorityCategory,
  }) async {
    try {
      final country = countryCode ?? 'id';
      List<Article> allArticles = [];

      // If priority category specified, fetch more from that category
      if (priorityCategory != null && priorityCategory.isNotEmpty) {
        try {
          final priorityArticles = await fetchNews(
            country,
            category: priorityCategory,
            pageSize: 10,
          );
          allArticles.addAll(priorityArticles);
        } catch (e) {
          print('Error fetching priority category: $e');
        }
      }

      // Fetch general news (no category filter for variety)
      try {
        final generalArticles = await fetchNews(
          country,
          pageSize: 10,
        );
        allArticles.addAll(generalArticles);
      } catch (e) {
        print('Error fetching general news: $e');
      }

      // Remove duplicates based on link
      final uniqueArticles = <String, Article>{};
      for (var article in allArticles) {
        uniqueArticles[article.link] = article;
      }

      return uniqueArticles.values.toList();
    } catch (e) {
      print('Error fetching mixed news: $e');
      rethrow;
    }
  }
}
