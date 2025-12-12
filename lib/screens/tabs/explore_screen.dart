import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/article_model.dart';
import '../../services/news_service.dart';
import '../news_detail_webview.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;
  List<Article> _allArticles = [];
  List<Article> _filteredArticles = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Category mapping to NewsData.io API categories
  final Map<String, String> _categoryMapping = {
    'Business': 'business',
    'Teknologi': 'technology',
    'Olahraga': 'sports',
    'Hiburan': 'entertainment',
    'Kesehatan': 'health',
    'Sains': 'science',
    'Politik': 'politics',
    'Dunia': 'world',
  };

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNews({String? category}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final articles = await NewsService.fetchNews(
        'id',
        category: category,
      );
      
      setState(() {
        _allArticles = articles;
        _filteredArticles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterNews(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredArticles = _allArticles;
      } else {
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

  void _selectCategory(String categoryName) {
    final apiCategory = _categoryMapping[categoryName];
    setState(() {
      _selectedCategory = categoryName;
      _searchController.clear();
    });
    _loadNews(category: apiCategory);
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'Teknologi':
        return Icons.computer;
      case 'Kesehatan':
        return Icons.favorite;
      case 'Olahraga':
        return Icons.sports_soccer;
      case 'Ekonomi':
        return Icons.business;
      case 'Travel':
        return Icons.flight;
      case 'Pendidikan':
        return Icons.school;
      case 'Hiburan':
        return Icons.movie;
      case 'Politik':
        return Icons.account_balance;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String categoryName) {
    switch (categoryName) {
      case 'Teknologi':
        return Colors.blue;
      case 'Kesehatan':
        return Colors.lightBlue;
      case 'Olahraga':
        return Colors.cyan;
      case 'Ekonomi':
        return Colors.indigo;
      case 'Travel':
        return Colors.teal;
      case 'Pendidikan':
        return Colors.blue[800]!;
      case 'Hiburan':
        return Colors.blueAccent;
      case 'Politik':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  Color _getCategoryIconColor(String categoryName) {
    switch (categoryName) {
      case 'Teknologi':
        return Colors.blue[700]!;
      case 'Kesehatan':
        return Colors.lightBlue[700]!;
      case 'Olahraga':
        return Colors.cyan[700]!;
      case 'Ekonomi':
        return Colors.indigo[700]!;
      case 'Travel':
        return Colors.teal[700]!;
      case 'Pendidikan':
        return Colors.blue[900]!;
      case 'Hiburan':
        return Colors.blueAccent[700]!;
      case 'Politik':
        return Colors.blueGrey[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  void _clearCategory() {
    setState(() {
      _selectedCategory = null;
      _searchController.clear();
    });
    _loadNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Modern Header
          SliverToBoxAdapter(
            child: Container(
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Center(
                    child: Image.asset(
                      'lib/images/logo/info-putih.png',
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Jelajahi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Cari berita berdasarkan kategori',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari berita...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, color: Colors.blue[600]),
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
                ],
              ),
            ),
          ),
          // Selected Category Chip
          if (_selectedCategory != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 8,
                  children: [
                    Chip(
                      label: Text(_selectedCategory!),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: _clearCategory,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ],
                ),
              ),
            ),
          // Categories Section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              margin: const EdgeInsets.only(top: 8),
              child: const Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Categories Horizontal List
          SliverToBoxAdapter(
            child: Container(
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dummyCategories.length,
                itemBuilder: (context, index) {
                  final category = dummyCategories[index];
                  final isSelected = _selectedCategory == category.name;
                  return Container(
                    width: 100,
                    margin: EdgeInsets.only(right: index < dummyCategories.length - 1 ? 12 : 0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _getCategoryColor(category.name).withOpacity(0.15),
                          _getCategoryColor(category.name).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _getCategoryColor(category.name).withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getCategoryColor(category.name).withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (isSelected) {
                            _clearCategory();
                          } else {
                            _selectCategory(category.name);
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        splashColor: _getCategoryColor(category.name).withOpacity(0.3),
                        highlightColor: _getCategoryColor(category.name).withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getCategoryColor(category.name).withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _getCategoryIcon(category.name),
                                  size: 24,
                                  color: _getCategoryIconColor(category.name),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _getCategoryIconColor(category.name),
                                  letterSpacing: 0.3,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Results Section Header
          if (_filteredArticles.isNotEmpty && !_isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Row(
                  children: [
                    Icon(
                      _searchController.text.isNotEmpty
                          ? Icons.search
                          : _selectedCategory != null
                              ? Icons.filter_list
                              : Icons.newspaper,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _searchController.text.isNotEmpty
                            ? 'Hasil Pencarian (${_filteredArticles.length})'
                            : _selectedCategory != null
                                ? 'Berita $_selectedCategory (${_filteredArticles.length})'
                                : 'Semua Berita',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Loading State
          if (_isLoading)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Memuat berita...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Error State
          if (_errorMessage != null && !_isLoading)
            SliverFillRemaining(
              child: Center(
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
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _loadNews(
                          category: _selectedCategory != null
                              ? _categoryMapping[_selectedCategory]
                              : null,
                        ),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Empty State
          if (_filteredArticles.isEmpty && !_isLoading && _errorMessage == null)
            SliverFillRemaining(
              child: Center(
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
                        'Coba kata kunci lain atau pilih kategori berbeda',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // News List
          if (_filteredArticles.isNotEmpty && !_isLoading)
            SliverFillRemaining(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _loadNews(
                    category: _selectedCategory != null
                        ? _categoryMapping[_selectedCategory]
                        : null,
                  );
                  // Re-apply search filter if active
                  if (_searchController.text.isNotEmpty) {
                    _filterNews(_searchController.text);
                  }
                  // Show feedback
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_selectedCategory != null 
                          ? 'Berita $_selectedCategory diperbarui'
                          : 'Berita diperbarui'),
                        duration: const Duration(seconds: 1),
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
                      child: _ArticleCard(article: article),
                    );
                  },
                ),
              ),
            ),
          // Bottom Padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }
}

// Article Card Widget
class _ArticleCard extends StatelessWidget {
  final Article article;

  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailWebview(
                    url: article.link,
                    title: article.title,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with Gradient Overlay
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
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
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Category Badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[600]!.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Berita',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                      ),
                      const SizedBox(height: 12),
                      // Description
                      if (article.description != null &&
                          article.description!.isNotEmpty)
                        Text(
                          article.description!,
                          maxLines: 3,
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
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.source,
                              size: 14,
                              color: Colors.blue[600],
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
                          if (article.pubDate.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.orange[600],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatDate(article.pubDate),
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
