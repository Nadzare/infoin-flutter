import 'package:flutter/material.dart';
import 'dart:async';
import '../services/auth_service.dart';
import 'onboarding_screen.dart';
import 'onboarding/country_selection_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    // Check if user is logged in
    final user = _authService.getCurrentUser();
    
    if (user != null) {
      print('👤 User logged in: ${user.id}');
      
      try {
        // PENTING: Pastikan profile ada di database
        await _authService.ensureProfileExists(
          user.id,
          email: user.email,
          fullName: user.userMetadata?['full_name'] ?? user.userMetadata?['name'],
        );
        
        // User sudah login, cek apakah sudah complete onboarding
        final hasCompletedOnboarding = await _authService.hasCompletedOnboarding(user.id);
        
        if (mounted) {
          if (hasCompletedOnboarding) {
            // Preferences sudah lengkap, langsung ke MainScreen
            print('✅ Navigating to MainScreen');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          } else {
            // User baru register, belum setup preferences
            // Arahkan ke CountrySelectionScreen untuk melanjutkan setup
            print('⚠️ Navigating to CountrySelectionScreen');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CountrySelectionScreen()),
            );
          }
        }
      } catch (e) {
        print('❌ Error in splash navigation: $e');
        // Jika ada error, arahkan ke CountrySelectionScreen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CountrySelectionScreen()),
          );
        }
      }
    } else {
      // Belum login, ke halaman onboarding/welcome
      print('🚪 No user, navigating to OnboardingScreen');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[50]!,
              Colors.white,
              Colors.blue[50]!,
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo from assets
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: Image.asset(
                      'assets/images/INFOIN (1).png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // App Name
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      children: [
                        TextSpan(
                          text: 'INFO',
                          style: TextStyle(
                            color: Colors.blue[900],
                          ),
                        ),
                        TextSpan(
                          text: 'IN',
                          style: TextStyle(
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'NEWS APP',
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 4,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Loading indicator
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
