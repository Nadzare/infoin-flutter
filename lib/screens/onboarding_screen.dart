import 'package:flutter/material.dart';
import 'auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Berita Terkini di Ujung Jari Anda',
      description:
          'Dapatkan berita terbaru dari berbagai sumber terpercaya, langsung di satu aplikasi. Infoin menghadirkan kabar terkini dengan tampilan yang cepat.',
      imageUrl: 'lib/images/landing/landing1.jpg',
    ),
    OnboardingData(
      title: 'Berita Sesuai Minatmu',
      description:
          'Pilih topik favoritmu seperti teknologi, ekonomi, hiburan, hingga olahraga. Infoin menyesuaikan konten agar kamu hanya melihat berita yang relevan.',
      imageUrl: 'lib/images/landing/landing2.jpg',
    ),
    OnboardingData(
      title: 'Selalu Terhubung dengan Dunia',
      description:
          'Akses berita kapan saja, di mana saja. Dengan Infoin, kamu tetap tahu perkembangan dunia secara real-time, tanpa batas waktu dan tempat.',
      imageUrl: 'lib/images/landing/landing3.jpg',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _getStarted() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _OnboardingPage(data: _pages[index]);
            },
          ),
          // Bottom Navigation (Dots Indicator + Buttons)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dots Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => _DotIndicator(isActive: index == _currentPage),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Navigation Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button (hanya muncul di halaman 2 dan 3)
                        if (_currentPage > 0)
                          TextButton.icon(
                            onPressed: _previousPage,
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Back'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 100),
                        // Next / Get Started Button
                        if (_currentPage < _pages.length - 1)
                          FilledButton.icon(
                            onPressed: _nextPage,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Next'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )
                        else
                          FilledButton.icon(
                            onPressed: _getStarted,
                            icon: const Icon(Icons.login),
                            label: const Text('Get Started'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image (mengisi setengah layar atas)
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(data.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Content (mengisi setengah layar bawah)
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface.withOpacity(0.95),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.2,
                        ),
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    data.description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final bool isActive;

  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue[600] : Colors.blue[200]!.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String imageUrl;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}
