












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
      print('📝 Starting signUp for: $email');
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'https://ogqndrylzpgaanzvbszn.supabase.co/auth/v1/verify',
      );

      if (response.user != null) {
        print('✅ User created with ID: ${response.user!.id}');
        print('💾 Creating profile in database...');
        
        try {
          await _supabase.from('profiles').insert({
            'id': response.user!.id,
            'full_name': fullName,
          });
          print('✅ Profile created successfully');
        } catch (profileError) {
          print('❌ Failed to create profile: $profileError');
          // Rethrow karena profile penting
          rethrow;
        }
      } else {
        print('⚠️ SignUp response has no user');
      }

      return response;
    } catch (e) {
      print('❌ SignUp error: $e');
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
          print('👤 Google Sign In successful for user: $userId');
          
          try {
            print('🔍 Checking existing profile...');
            final existingProfile = await _supabase
                .from('profiles')
                .select()
                .eq('id', userId)
                .maybeSingle();

            if (existingProfile == null) {
              print('💾 Creating new profile for Google user...');
              await _supabase.from('profiles').insert({
                'id': userId,
                'full_name': googleUser.displayName ?? 'User',
                'avatar_url': googleUser.photoUrl,
              });
              print('✅ Profile created successfully');
            } else {
              print('✅ Profile already exists');
            }
          } catch (e) {
            print('❌ Error saat memeriksa/membuat profile: $e');
            // Rethrow karena profile penting
            rethrow;
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
      print('🔍 Fetching profile for user: $userId');
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      
      if (response == null) {
        print('❌ No profile found for user: $userId');
      } else {
        print('✅ Profile found: $response');
      }
      
      return response;
    } catch (e) {
      print('❌ getUserProfile error: $e');
      rethrow;
    }
  }

  // Helper function untuk memastikan profile exists
  Future<void> ensureProfileExists(String userId, {String? email, String? fullName}) async {
    try {
      print('🔧 Ensuring profile exists for user: $userId');
      
      final existingProfile = await getUserProfile(userId);
      
      if (existingProfile == null) {
        print('📝 Profile not found, creating new one...');
        
        // Ambil data dari auth user jika tidak ada parameter
        final user = _supabase.auth.currentUser;
        final profileName = fullName ?? user?.userMetadata?['full_name'] ?? user?.userMetadata?['name'] ?? 'User';
        
        // Hanya insert kolom yang ada di tabel profiles
        // Berdasarkan error, tabel tidak punya kolom 'email'
        await _supabase.from('profiles').insert({
          'id': userId,
          'full_name': profileName,
        });
        
        print('✅ Profile created successfully');
      } else {
        print('✅ Profile already exists');
      }
    } catch (e) {
      print('❌ ensureProfileExists error: $e');
      rethrow;
    }
  }

  Future<bool> hasCompletedOnboarding(String userId) async {
    try {
      final profile = await getUserProfile(userId);
      
      if (profile == null) {
        print('❌ hasCompletedOnboarding: Profile null');
        return false;
      }
      
      final country = profile['country'];
      final topics = profile['selected_topics'];
      
      print('🔍 hasCompletedOnboarding check:');
      print('   User ID: $userId');
      print('   Country: $country');
      print('   Topics: $topics');
      print('   Topics type: ${topics.runtimeType}');
      
      final hasCountry = country != null && country.toString().isNotEmpty;
      final hasTopics = topics != null && topics is List && (topics as List).isNotEmpty;
      
      print('   Has Country: $hasCountry');
      print('   Has Topics: $hasTopics');
      print('   Result: ${hasCountry && hasTopics}');
      
      return hasCountry && hasTopics;
    } catch (e) {
      print('❌ hasCompletedOnboarding error: $e');
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
      
      print('💾 Updating profile:');
      print('   User ID: $userId');
      print('   Updates: $updates');
      
      if (updates.isNotEmpty) {
        await _supabase
            .from('profiles')
            .update(updates)
            .eq('id', userId);
        print('✅ Profile updated successfully');
      } else {
        print('⚠️ No updates to save');
      }
    } catch (e) {
      print('❌ updateProfile error: $e');
      rethrow;
    }
  }
}
