import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'register_screen.dart';
import '../main_screen.dart';
import '../onboarding/country_selection_screen.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _hasNavigated = false;
  late final StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    
    // Listen untuk OAuth redirect (Web only)
    if (kIsWeb) {
      print('🌐 Web platform detected - Setting up auth listener');
      _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
        final session = data.session;
        print('🔔 Auth state changed: ${data.event}');
        if (session != null && mounted) {
          print('✅ Session detected, handling auth success');
          final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
          _handleAuthSuccess(context, authViewModel);
        }
      });
    } else {
      _authSubscription = null;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    if (kIsWeb && _authSubscription != null) {
      _authSubscription!.cancel();
    }
    super.dispose();
  }

  Future<void> _handleAuthSuccess(BuildContext context, AuthViewModel authViewModel) async {
    // Prevent multiple navigation
    if (_hasNavigated) {
      print('⚠️ Navigation already handled, skipping...');
      return;
    }
    
    _hasNavigated = true;
    
    try {
      print('🔐 handleAuthSuccess - checking onboarding status');
      
      if (!mounted) return;

      if (authViewModel.hasCompletedOnboarding) {
        print('✅ User has completed onboarding -> Navigate to MainScreen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        print('⚠️ User has NOT completed onboarding -> Navigate to CountrySelectionScreen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CountrySelectionScreen(),
          ),
        );
      }
    } catch (e) {
      print('❌ Error handling auth success: $e');
      
      // Jika ada error, tetap arahkan ke CountrySelectionScreen sebagai fallback
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CountrySelectionScreen(),
          ),
        );
      }
    }
  }

  Future<void> _handleLogin(AuthViewModel authViewModel) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan password tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Gunakan ViewModel untuk sign in
    final success = await authViewModel.signIn(
      email: email,
      password: password,
    );

    if (!mounted) return;

    if (success) {
      // Login berhasil, navigate
      await _handleAuthSuccess(context, authViewModel);
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.errorMessage ?? 'Login gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleGoogleLogin(AuthViewModel authViewModel) async {
    if (kIsWeb) {
      // Web: Trigger OAuth redirect
      await authViewModel.signInWithGoogle();
      // Loading state akan tetap true karena browser akan redirect
      // Auth state listener akan handle navigation setelah redirect kembali
    } else {
      // Mobile: Handle native Google Sign-In
      final success = await authViewModel.signInWithGoogle();

      if (!mounted) return;

      if (success) {
        await _handleAuthSuccess(context, authViewModel);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authViewModel.errorMessage ?? 'Google Sign In gagal'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/images/logo/login.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black,
                      BlendMode.color,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),
                      // Logo
                      Center(
                        child: Image.asset(
                          'lib/images/logo/info-putih.png',
                          height: 70,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Email Field
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.white70),
                          hintText: 'nama@email.com',
                          hintStyle: const TextStyle(color: Colors.white54),
                          prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white54),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Password Field
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white70),
                          hintText: '••••••••',
                          hintStyle: const TextStyle(color: Colors.white54),
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white54),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implement forgot password
                          },
                          child: const Text(
                            'Lupa Password?',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Login Button
                      FilledButton(
                        onPressed: authViewModel.isLoading ? null : () => _handleLogin(authViewModel),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: authViewModel.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Masuk',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                      const SizedBox(height: 24),
                      // Divider
                      Row(
                        children: [
                          const Expanded(child: Divider(color: Colors.white54)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: const Text(
                              'atau',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          const Expanded(child: Divider(color: Colors.white54)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Google Login Button
                      OutlinedButton.icon(
                        onPressed: authViewModel.isLoading ? null : () => _handleGoogleLogin(authViewModel),
                        icon: const Text(
                          'G',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        label: const Text(
                          'Masuk dengan Google',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.blue[900]!.withOpacity(0.5),
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white.withOpacity(0.3)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Belum punya akun? ',
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Daftar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
