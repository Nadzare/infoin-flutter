import 'package:flutter/material.dart';
import '../../widgets/community_news_card.dart';
import '../../services/news_service.dart';
import '../../services/community_news_service.dart';
import '../../services/history_service.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../../models/article_model.dart';
import '../../models/community_news_model.dart';
import '../../models/news_model.dart';
import '../create_news_screen.dart';
import '../news_detail_webview.dart';
import '../notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<_CommunityNewsTabState> _communityTabKey = GlobalKey();
  final AuthService _authService = AuthService();
  String _userName = 'Guest';
  bool _isLoadingName = true;
  int _unreadNotificationCount = 0;
  
  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadNotificationCount();
  }
  
  Future<void> _loadNotificationCount() async {
    final count = await NotificationService.getUnreadCount();
    if (mounted) {
      setState(() {
        _unreadNotificationCount = count;
      });
    }
  }
  
  Future<void> _loadUserName() async {
    try {
      final user = _authService.getCurrentUser();
      print('Current user: ${user?.id}'); // Debug
      
      if (user != null) {
        final profile = await _authService.getUserProfile(user.id);
        print('Profile data: $profile'); // Debug
        
        if (profile != null && profile['full_name'] != null) {
          if (mounted) {
            setState(() {
              _userName = profile['full_name'];
              _isLoadingName = false;
            });
          }
        } else {
          // Fallback to email if no full_name
          if (mounted) {
            setState(() {
              _userName = user.email?.split('@')[0] ?? 'User';
              _isLoadingName = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _userName = 'Guest';
            _isLoadingName = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user name: $e'); // Debug
      if (mounted) {
        setState(() {
          _userName = 'User';
          _isLoadingName = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Custom Header with Profile
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('lib/images/logo/header1.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Logo
                      Center(
                        child: Image.asset(
                          'lib/images/logo/info-putih.png',
                          height: 70,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // User Profile Row
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blue[100],
                            child: Icon(
                              Icons.person,
                              color: Colors.blue[700],
                              size: 28,
                            ),
                          ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            _isLoadingName
                                ? SizedBox(
                                    width: 100,
                                    height: 20,
                                    child: LinearProgressIndicator(
                                      backgroundColor: Colors.grey[200],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue[300]!,
                                      ),
                                    ),
                                  )
                                : Text(
                                    _userName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.notifications_outlined,
                                color: Colors.blue[700],
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const NotificationsScreen(),
                                  ),
                                );
                                // Reload notification count when coming back
                                _loadNotificationCount();
                              },
                            ),
                            if (_unreadNotificationCount > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Text(
                                    _unreadNotificationCount > 99
                                        ? '99+'
                                        : '$_unreadNotificationCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // TabBar
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 3,
                      labelColor: Colors.blue[700],
                      unselectedLabelColor: Colors.grey[600],
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: const [
                        Tab(text: 'Berita Global'),
                        Tab(text: 'Komunitas'),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              // Tab 1: Berita Global
              _GlobalNewsTab(),
              // Tab 2: Komunitas
              _CommunityNewsTab(key: _communityTabKey),
            ],
          ),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.blue[400]!, Colors.blue[700]!],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateNewsScreen(),
                ),
              );
              
              // Refresh community news if post was successful
              if (result == true && _communityTabKey.currentState != null) {
                _communityTabKey.currentState!.setState(() {
                  _communityTabKey.currentState!._loadCommunityNews();
                });
              }
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

// Delegate for pinned TabBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._widget);

  final Widget _widget;

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _widget;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

// Global News Tab Content
class _GlobalNewsTab extends StatefulWidget {
  @override
  State<_GlobalNewsTab> createState() => _GlobalNewsTabState();
}

class _GlobalNewsTabState extends State<_GlobalNewsTab> {
  late Future<List<Article>> _newsFuture;
  final _searchController = TextEditingController();
  List<Article> _allArticles = [];
  List<Article> _filteredArticles = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Fetch mixed news with variety from different categories
    // TODO: Get preferred category from user preferences (dari onboarding)
    _loadNews();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadNews() {
    _newsFuture = NewsService.fetchMixedNews(
      'id',
      priorityCategory: 'technology', // TODO: Get from user preferences
    );
  }

  void _filterNews(String query) {
    setState(() {
      if (query.isEmpty) {
        _isSearching = false;
        _filteredArticles = [];
      } else {
        _isSearching = true;
        _filteredArticles = _allArticles.where((article) {
          final titleLower = article.title.toLowerCase();
          final descLower = article.description?.toLowerCase() ?? '';
          final searchLower = query.toLowerCase();
          return titleLower.contains(searchLower) ||
                 descLower.contains(searchLower);
        }).toList();
      }
    });
  }

  void _showCategoryFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Kategori',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildCategoryFilterChip('Semua', Icons.apps),
                  _buildCategoryFilterChip('Bisnis', Icons.business),
                  _buildCategoryFilterChip('Teknologi', Icons.computer),
                  _buildCategoryFilterChip('Olahraga', Icons.sports_soccer),
                  _buildCategoryFilterChip('Hiburan', Icons.movie),
                  _buildCategoryFilterChip('Kesehatan', Icons.favorite),
                  _buildCategoryFilterChip('Sains', Icons.science),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilterChip(String label, IconData icon) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Filter: $label'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
        // TODO: Implement category filtering
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar & Banner Section
        Container(
          color: Colors.white,
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _filterNews('');
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          onChanged: (value) {
                            _filterNews(value);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        _showCategoryFilterDialog(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.tune,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Promo Banner
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateNewsScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[400]!, Colors.blue[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Ada berita menarik?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Bagikan sekarang!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.blue[600],
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Buat Berita',
                                      style: TextStyle(
                                        color: Colors.blue[600],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.newspaper,
                            size: 48,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // News List
        Expanded(
          child: _isSearching
              ? _buildSearchResults()
              : _buildNewsList(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_filteredArticles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Tidak ada hasil',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coba kata kunci lain',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Reload news dari API saat refresh
        setState(() {
          _loadNews();
        });
        await _newsFuture;
        // Re-apply search filter
        _filterNews(_searchController.text);
        // Show feedback
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Berita diperbarui'),
              duration: Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _filteredArticles.length,
        itemBuilder: (context, index) {
          final article = _filteredArticles[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _ArticleCard(article: article, index: index),
          );
        },
      ),
    );
  }

  Widget _buildNewsList() {
    return FutureBuilder<List<Article>>(
      future: _newsFuture,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Memuat berita terbaru...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat berita',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _loadNews();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        // Empty state
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.newspaper_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada berita',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Belum ada berita tersedia saat ini',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        }

        // Success state - display news
        final articles = snapshot.data!;
        // Store articles for search functionality
        _allArticles = articles;
        
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _loadNews();
            });
            await _newsFuture;
            // Show feedback
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Berita diperbarui'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              // Top Category Section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Top Category',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _showCategoryFilterDialog(context);
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(color: Colors.blue[600]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 90,
                      child: Row(
                        children: [
                          _CategoryChip(
                            icon: Icons.business,
                            label: 'Business',
                            color: Colors.blue[100]!,
                            iconColor: Colors.blue[700]!,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Filter: Business'),
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          _CategoryChip(
                            icon: Icons.sports_soccer,
                            label: 'Sports',
                            color: Colors.orange[100]!,
                            iconColor: Colors.orange[700]!,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Filter: Sports'),
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          _CategoryChip(
                            icon: Icons.computer,
                            label: 'Tech',
                            color: Colors.purple[100]!,
                            iconColor: Colors.purple[700]!,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Filter: Tech'),
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Popular News Section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Popular News',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: View all news
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(color: Colors.blue[600]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // News Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: articles.map((article) {
                    final index = articles.indexOf(article);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _ArticleCard(article: article, index: index),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Category Chip Widget
class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final VoidCallback? onTap;

  const _CategoryChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Article Card Widget for API data
class _ArticleCard extends StatelessWidget {
  final Article article;
  final int index;

  const _ArticleCard({required this.article, required this.index});

  @override
  Widget build(BuildContext context) {
    // Alternate card styles for uniqueness
    final isAlternateStyle = index % 2 == 1;
    final cardColor = isAlternateStyle ? Colors.grey[50] : Colors.white;
    final borderRadius = isAlternateStyle ? BorderRadius.circular(16) : BorderRadius.circular(20);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: isAlternateStyle ? 10 : 15,
            offset: Offset(0, isAlternateStyle ? 4 : 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Material(
          color: cardColor,
          child: InkWell(
            onTap: () async {
              // Convert Article to NewsArticle and add to history
              final news = NewsArticle(
                id: article.link.hashCode.toString(),
                title: article.title,
                description: article.description ?? '',
                imageUrl: article.imageUrl,
                publishedAt: DateTime.tryParse(article.pubDate) ?? DateTime.now(),
                source: article.sourceId,
                category: 'General',
                content: article.content ?? '',
                url: article.link,
              );

              await HistoryService.addToRecentlyViewed(news);

              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailWebview(
                      url: article.link,
                      title: article.title,
                    ),
                  ),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with Gradient Overlay
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: isAlternateStyle ? 21 / 9 : 16 / 9,
                      child: Image.network(
                        article.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 64,
                              color: Colors.grey,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Gradient Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(isAlternateStyle ? 0.3 : 0.4),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Trending Badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isAlternateStyle
                              ? Colors.purple[600]!.withOpacity(0.9)
                              : Colors.red[600]!.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isAlternateStyle ? Icons.star : Icons.trending_up,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isAlternateStyle ? 'Featured' : 'Trending',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Read Time Badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${(index % 3 + 2)} min',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Category Badge (alternate style)
                    if (isAlternateStyle)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[600]!.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'News',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        article.title,
                        maxLines: isAlternateStyle ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                              fontSize: isAlternateStyle ? 18 : 20,
                            ),
                      ),
                      const SizedBox(height: 12),
                      // Description
                      if (article.description != null &&
                          article.description!.isNotEmpty)
                        Text(
                          article.description!,
                          maxLines: isAlternateStyle ? 3 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            height: 1.5,
                            fontSize: 14,
                          ),
                        ),
                      const SizedBox(height: 16),
                      // Meta info with better styling
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isAlternateStyle ? Colors.purple[50] : Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.source,
                              size: 14,
                              color: isAlternateStyle ? Colors.purple[600] : Colors.blue[600],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              article.sourceId,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isAlternateStyle ? Colors.orange[50] : Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.visibility,
                              size: 14,
                              color: isAlternateStyle ? Colors.orange[600] : Colors.green[600],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(index * 23 + 45) % 100}K views',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}h lalu';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}j lalu';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m lalu';
      } else {
        return 'Baru saja';
      }
    } catch (e) {
      return dateString;
    }
  }
}

// Community News Tab Content
class _CommunityNewsTab extends StatefulWidget {
  const _CommunityNewsTab({super.key});

  @override
  State<_CommunityNewsTab> createState() => _CommunityNewsTabState();
}

class _CommunityNewsTabState extends State<_CommunityNewsTab> {
  late Future<List<CommunityNews>> _communityNewsFuture;

  @override
  void initState() {
    super.initState();
    _loadCommunityNews();
  }

  void _loadCommunityNews() {
    _communityNewsFuture = CommunityNewsService.fetchCommunityNews();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CommunityNews>>(
      future: _communityNewsFuture,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Memuat berita komunitas...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat berita',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _loadCommunityNews();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        // Empty state
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada berita komunitas',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Jadilah yang pertama berbagi berita!',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        }

        // Success state
        final communityNews = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _loadCommunityNews();
            });
            await _communityNewsFuture;
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Berita komunitas diperbarui'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: communityNews.length,
            itemBuilder: (context, index) {
              final news = communityNews[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CommunityNewsCard(news: news),
              );
            },
          ),
        );
      },
    );
  }
}
