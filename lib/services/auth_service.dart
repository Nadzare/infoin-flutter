import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // Sign Up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Sign up user
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'https://ogqndrylzpgaanzvbszn.supabase.co/auth/v1/verify',
      );

      // If sign up successful, insert profile data
      if (response.user != null) {
        await _supabase.from('profiles').insert({
          'id': response.user!.id,
          'email': email,
          'full_name': fullName,
        });
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign In with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile from database
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Check if user has completed onboarding
  Future<bool> hasCompletedOnboarding(String userId) async {
    try {
      final profile = await getUserProfile(userId);
      
      if (profile == null) return false;
      
      // Check if country and selected_topics are not null/empty
      final country = profile['country'];
      final topics = profile['selected_topics'];
      
      return country != null && 
             country.toString().isNotEmpty &&
             topics != null;
    } catch (e) {
      return false;
    }
  }

  // Update user profile (for onboarding completion)
  Future<void> updateProfile({
    required String userId,
    String? country,
    List<String>? selectedTopics,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      
      if (country != null) {
        updates['country'] = country;
      }
      
      if (selectedTopics != null) {
        updates['selected_topics'] = selectedTopics;
      }
      
      if (updates.isNotEmpty) {
        await _supabase
            .from('profiles')
            .update(updates)
            .eq('id', userId);
      }
    } catch (e) {
      rethrow;
    }
  }
}
