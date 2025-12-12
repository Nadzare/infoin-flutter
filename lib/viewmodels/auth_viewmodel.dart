import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import 'base_viewmodel.dart';

/// ViewModel untuk mengelola authentication logic
/// Memisahkan business logic dari UI
class AuthViewModel extends BaseViewModel {
  final AuthService _authService = AuthService();
  
  User? _currentUser;
  bool _hasCompletedOnboarding = false;

  /// Getter untuk current user
  User? get currentUser => _currentUser;

  /// Getter untuk onboarding status
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  /// Initialize - panggil saat app start
  Future<void> initialize() async {
    _currentUser = _authService.getCurrentUser();
    if (_currentUser != null) {
      await checkOnboardingStatus();
    }
    notifyListeners();
  }

  /// Check apakah user sudah complete onboarding
  Future<void> checkOnboardingStatus() async {
    if (_currentUser == null) return;
    
    try {
      _hasCompletedOnboarding = await _authService.hasCompletedOnboarding(_currentUser!.id);
      notifyListeners();
    } catch (e) {
      print('Error checking onboarding status: $e');
      _hasCompletedOnboarding = false;
    }
  }

  /// Sign in dengan email dan password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    return await runWithLoading(() async {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _currentUser = response.user;
        
        // Ensure profile exists
        await _authService.ensureProfileExists(
          response.user!.id,
          email: response.user!.email,
          fullName: response.user!.userMetadata?['full_name'] ?? response.user!.userMetadata?['name'],
        );
        
        // Check onboarding status
        await checkOnboardingStatus();
        
        return true;
      }
      return false;
    }) ?? false;
  }

  /// Sign up dengan email, password, dan nama
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await runWithLoading(() async {
      final response = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );

      if (response.user != null) {
        _currentUser = response.user;
        _hasCompletedOnboarding = false; // New user hasn't completed onboarding
        return true;
      }
      return false;
    }) ?? false;
  }

  /// Sign in dengan Google
  Future<bool> signInWithGoogle() async {
    return await runWithLoading(() async {
      final response = await _authService.signInWithGoogle();

      if (response.user != null) {
        _currentUser = response.user;
        
        // Ensure profile exists
        await _authService.ensureProfileExists(
          response.user!.id,
          email: response.user!.email,
          fullName: response.user!.userMetadata?['full_name'] ?? response.user!.userMetadata?['name'],
        );
        
        // Check onboarding status
        await checkOnboardingStatus();
        
        return true;
      }
      return false;
    }) ?? false;
  }

  /// Sign out
  Future<void> signOut() async {
    await runWithLoading(() async {
      await _authService.signOut();
      _currentUser = null;
      _hasCompletedOnboarding = false;
    });
  }

  /// Update user profile (country & topics)
  Future<bool> updateProfile({
    String? country,
    List<String>? selectedTopics,
  }) async {
    if (_currentUser == null) return false;

    return await runWithLoading(() async {
      await _authService.updateProfile(
        userId: _currentUser!.id,
        country: country,
        selectedTopics: selectedTopics,
      );
      
      // Update onboarding status after profile update
      await checkOnboardingStatus();
      return true;
    }) ?? false;
  }

  /// Get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (_currentUser == null) return null;
    
    try {
      return await _authService.getUserProfile(_currentUser!.id);
    } catch (e) {
      errorMessage = e.toString();
      return null;
    }
  }
}
