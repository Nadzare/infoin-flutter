import 'package:flutter/material.dart';
import '../../widgets/community_news_card.dart';
import '../../widgets/recent_news_card.dart';
import '../settings_screen.dart';
import '../../services/auth_service.dart';
import '../../services/community_news_service.dart';
import '../../services/history_service.dart';
import '../../models/community_news_model.dart';
import '../../models/news_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  
  Map<String, dynamic>? _userProfile;
  List<CommunityNews> _userPosts = [];
  List<NewsArticle> _recentlyViewed = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _authService.getCurrentUser();
      
      if (user == null) {
        setState(() {
          _errorMessage = 'User not logged in';
          _isLoading = false;
        });
        return;
      }

      // Fetch user profile
      final profile = await _authService.getUserProfile(user.id);
      
      // Fetch all community news and filter user posts
      final allNews = await CommunityNewsService.fetchCommunityNews();
      final userPosts = allNews.where((news) => news.userId == user.id).toList();

      // Fetch recently viewed news
      final recentlyViewed = await HistoryService.getRecentlyViewed();

      setState(() {
        _userProfile = profile;
        _userPosts = userPosts;
        _recentlyViewed = recentlyViewed;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading profile: $e';
        _isLoading = false;
      });
    }
  }

  String _getUserDisplayName() {
    if (_userProfile != null && _userProfile!['full_name'] != null) {
      return _userProfile!['full_name'];
    }
    final user = _authService.getCurrentUser();
    return user?.email?.split('@')[0] ?? 'User';
  }

  String _getUserEmail() {
    final user = _authService.getCurrentUser();
    return user?.email ?? 'No email';
  }

  String _getUserAvatar() {
    // Return first letter of name
    return _getUserDisplayName()[0].toUpperCase();
  }

  int _getTotalLikes() {
    return _userPosts.fold<int>(0, (sum, news) => sum + news.likesCount);
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Riwayat'),
        content: const Text('Apakah Anda yakin ingin menghapus semua riwayat berita yang sudah dilihat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await HistoryService.clearRecentlyViewed();
              await _loadUserData();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Riwayat berhasil dihapus'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadUserData,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: CustomScrollView(
          slivers: [
          // Modern Profile Header
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('lib/images/logo/header1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Logo
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 8),
                      child: Center(
                        child: Image.asset(
                          'lib/images/logo/info-putih.png',
                          height: 70,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // App Bar with Settings
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Stack(
                        children: [
                          Center(
                            child: const Text(
                              'Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.settings, color: Colors.white),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SettingsScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Profile Avatar & Info
                    CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.blue[100],
                          backgroundImage: _userProfile?['avatar_url'] != null
                              ? NetworkImage(_userProfile!['avatar_url'])
                              : null,
                          child: _userProfile?['avatar_url'] == null
                              ? Text(
                                  _getUserAvatar(),
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _getUserDisplayName(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getUserEmail(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Stats Cards
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _ModernStatCard(
                                icon: Icons.article_outlined,
                                label: 'Postingan',
                                value: '${_userPosts.length}',
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ModernStatCard(
                                icon: Icons.visibility_outlined,
                                label: 'Terbaca',
                                value: '${_recentlyViewed.length}',
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ModernStatCard(
                                icon: Icons.favorite_outline,
                                label: 'Disukai',
                                value: '${_getTotalLikes()}',
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          // Recently Viewed Section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Baru Dilihat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_recentlyViewed.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_recentlyViewed.length}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (_recentlyViewed.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        _showClearHistoryDialog();
                      },
                      child: const Text('Hapus'),
                    ),
                ],
              ),
            ),
          ),
          // Recently Viewed Horizontal List
          _recentlyViewed.isEmpty
              ? SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.history,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Belum Ada Riwayat',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Berita yang Anda baca akan muncul di sini',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _recentlyViewed.length,
                      itemBuilder: (context, index) {
                        return RecentNewsCard(news: _recentlyViewed[index]);
                      },
                    ),
                  ),
                ),
          // User Posts Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Postingan Saya',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (_userPosts.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_userPosts.length}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // User Posts List or Empty State
          _userPosts.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada postingan',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mulai berbagi cerita Anda dengan komunitas',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[500],
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CommunityNewsCard(news: _userPosts[index]),
                        );
                      },
                      childCount: _userPosts.length,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _ModernStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ModernStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
