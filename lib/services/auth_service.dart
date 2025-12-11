












import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  static const String webClientId = '856961816595-ilpgjv5v3vshgbeq2uh567c5ldsrtmvs.apps.googleusercontent.com';

  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'https://ogqndrylzpgaanzvbszn.supabase.co/auth/v1/verify',
      );

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

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // WEB: Gunakan Supabase OAuth (akan redirect browser)
        print('🌐 Web Platform: Menggunakan Supabase OAuth');
        
        final response = await _supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: 'http://localhost:5000',
          authScreenLaunchMode: LaunchMode.platformDefault,
        );

        if (!response) {
          throw Exception('Gagal membuka halaman Google Sign In');
        }

        // Note: Browser akan redirect, fungsi ini tidak return AuthResponse
        // melainkan return bool untuk indicate apakah redirect berhasil
        // AuthResponse akan di-handle oleh auth state listener
        return AuthResponse(); // Return empty, actual response dari callback
        
      } else {
        // MOBILE/ANDROID: Gunakan google_sign_in package (Native)
        print('📱 Mobile Platform: Menggunakan Native Google Sign-In');
        
        final GoogleSignIn googleSignIn = GoogleSignIn(
          serverClientId: webClientId,
          scopes: [
            'email',
            'profile',
            'openid',
          ],
        );

        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        
        if (googleUser == null) {
          throw Exception('Google Sign In dibatalkan');
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Debug logging
        print('Access Token: ${googleAuth.accessToken != null ? "✓ Ada" : "✗ Null"}');
        print('ID Token: ${googleAuth.idToken != null ? "✓ Ada" : "✗ Null"}');

        if (googleAuth.accessToken == null) {
          throw Exception('Gagal mendapatkan access token dari Google');
        }

        if (googleAuth.idToken == null) {
          throw Exception('Gagal mendapatkan ID token dari Google. Pastikan scope "openid" aktif.');
        }

        final AuthResponse response = await _supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: googleAuth.idToken!,
          accessToken: googleAuth.accessToken,
        );

        // Auto-create profile untuk user baru
        if (response.user != null) {
          final userId = response.user!.id;
          
          try {
            final existingProfile = await _supabase
                .from('profiles')
                .select()
                .eq('id', userId)
                .maybeSingle();

            if (existingProfile == null) {
              await _supabase.from('profiles').insert({
                'id': userId,
                'email': googleUser.email,
                'full_name': googleUser.displayName ?? 'User',
                'avatar_url': googleUser.photoUrl,
              });
            }
          } catch (e) {
            print('Error saat memeriksa/membuat profile: $e');
          }
        }

        return response;
      }
    } catch (e) {
      print('Error Google Sign In: $e');
      rethrow;
    }
  }

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

  Future<bool> hasCompletedOnboarding(String userId) async {
    try {
      final profile = await getUserProfile(userId);
      
      if (profile == null) return false;
      
      final country = profile['country'];
      final topics = profile['selected_topics'];
      
      return country != null && 
             country.toString().isNotEmpty &&
             topics != null;
    } catch (e) {
      return false;
    }
  }

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
