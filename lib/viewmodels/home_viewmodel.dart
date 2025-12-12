import '../models/article_model.dart';
import '../models/community_news_model.dart';
import '../services/news_service.dart';
import '../services/community_news_service.dart';
import '../services/auth_service.dart';
import 'base_viewmodel.dart';

/// ViewModel untuk Home Screen
/// Mengelola news data dan community news
class HomeViewModel extends BaseViewModel {
  final AuthService _authService = AuthService();
  
  List<Article> _articles = [];
  List<CommunityNews> _communityNews = [];
  String _userName = 'Guest';
  int _unreadNotificationCount = 0;

  /// Getters
  List<Article> get articles => _articles;
  List<CommunityNews> get communityNews => _communityNews;
  String get userName => _userName;
  int get unreadNotificationCount => _unreadNotificationCount;

  /// Initialize - load all data
  Future<void> initialize() async {
    await Future.wait([
      loadUserName(),
      loadNews(),
      loadCommunityNews(),
    ]);
  }

  /// Load user name from profile
  Future<void> loadUserName() async {
    try {
      final user = _authService.getCurrentUser();
      
      if (user != null) {
        final profile = await _authService.getUserProfile(user.id);
        
        if (profile != null && profile['full_name'] != null) {
          _userName = profile['full_name'];
        } else {
          _userName = user.email?.split('@')[0] ?? 'User';
        }
      } else {
        _userName = 'Guest';
      }
      
      notifyListeners();
    } catch (e) {
      print('Error loading user name: $e');
      _userName = 'User';
      notifyListeners();
    }
  }

  /// Load news articles
  Future<void> loadNews({String? category}) async {
    await runWithLoading(() async {
      _articles = await NewsService.fetchNews(
        'id', // TODO: Get from user preferences
        category: category,
      );
      notifyListeners();
    });
  }

  /// Load community news
  Future<void> loadCommunityNews() async {
    await runWithLoading(() async {
      _communityNews = await CommunityNewsService.fetchCommunityNews();
      notifyListeners();
    });
  }

  /// Refresh all data
  Future<void> refresh() async {
    await Future.wait([
      loadNews(),
      loadCommunityNews(),
    ]);
  }

  /// Filter news by search query
  List<Article> filterNews(String query) {
    if (query.isEmpty) return _articles;
    
    final searchLower = query.toLowerCase();
    return _articles.where((article) {
      final titleLower = article.title.toLowerCase();
      final descLower = article.description?.toLowerCase() ?? '';
      return titleLower.contains(searchLower) || descLower.contains(searchLower);
    }).toList();
  }

  /// Update notification count
  void updateNotificationCount(int count) {
    _unreadNotificationCount = count;
    notifyListeners();
  }
}
