import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/onboarding/country_selection_screen.dart';
import 'screens/main_screen.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';

// Supabase Configuration
const String supabaseUrl = 'https://ogqndrylzpgaanzvbszn.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ncW5kcnlsenBnYWFuenZic3puIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ3ODk5NTMsImV4cCI6MjA4MDM2NTk1M30.zKnDCwijOzvGxhq_xUgwv0fQ8BiZ3vmjtOgkdBEwurw';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  
  runApp(const InfoinApp());
}

class InfoinApp extends StatelessWidget {
  const InfoinApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup MultiProvider untuk MVVM
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MaterialApp(
        title: 'Infoin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0097A7), // Teal color
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

// Auth Gate - Check login status and redirect accordingly
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoading = true;
  Widget _initialScreen = const LoginScreen();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      
      // Check if user is authenticated
      if (session?.user != null) {
        // User is logged in, check profile completion
        final profile = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', session!.user.id)
            .maybeSingle();
        
        if (profile != null) {
          final country = profile['country'];
          final topics = profile['selected_topics'];
          
          // Check if onboarding is completed
          if (country != null && country.toString().isNotEmpty && topics != null) {
            // Profile complete, go to MainScreen
            _initialScreen = const MainScreen();
          } else {
            // Profile incomplete, go to onboarding
            _initialScreen = const CountrySelectionScreen();
          }
        } else {
          // No profile found, go to onboarding
          _initialScreen = const CountrySelectionScreen();
        }
      } else {
        // Not logged in, go to LoginScreen
        _initialScreen = const LoginScreen();
      }
    } catch (e) {
      debugPrint('Auth check error: $e');
      _initialScreen = const LoginScreen();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.newspaper,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Infoin',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 40),
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      );
    }
    
    return _initialScreen;
  }
}
