# MVVM Architecture Implementation

## 📐 Struktur Arsitektur

Aplikasi **Infoin** sekarang menggunakan **MVVM (Model-View-ViewModel)** architecture pattern dengan **Provider** sebagai state management.

```
lib/
├── models/                     # Model Layer
│   ├── article_model.dart
│   ├── news_model.dart
│   ├── chat_model.dart
│   └── ...
├── viewmodels/                 # ViewModel Layer ✨ BARU
│   ├── base_viewmodel.dart    # Base class untuk semua ViewModel
│   ├── auth_viewmodel.dart    # Handle authentication logic
│   └── home_viewmodel.dart    # Handle home screen logic
├── views/                      # View Layer
│   ├── screens/
│   │   ├── auth/
│   │   │   └── login_screen.dart
│   │   └── tabs/
│   │       └── home_screen.dart
│   └── widgets/
├── services/                   # Repository/Service Layer
│   ├── auth_service.dart
│   ├── news_service.dart
│   └── ...
└── main.dart                   # Setup MultiProvider
```

## 🔄 Flow Diagram

```
┌─────────────┐
│    View     │  (UI - StatelessWidget/StatefulWidget)
│  (Screen)   │  - Menggunakan Consumer/Provider.of
└──────┬──────┘  - Hanya tampilkan UI
       │         - Tidak ada business logic
       ↓
┌─────────────┐
│  ViewModel  │  (Business Logic - ChangeNotifier)
│             │  - State management
└──────┬──────┘  - Business logic
       │         - notifyListeners() untuk update UI
       ↓
┌─────────────┐
│   Service   │  (Data Layer)
│  Repository │  - API calls
└──────┬──────┘  - Database operations
       │         - External services
       ↓
┌─────────────┐
│    Model    │  (Data Class)
│             │  - Plain Dart classes
└─────────────┘  - fromJson/toJson
```

## ✅ Implementasi

### 1. BaseViewModel

Base class yang menyediakan fungsi umum:

```dart
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Helper method untuk run async dengan loading state
  Future<T?> runWithLoading<T>(Future<T> Function() operation) async {
    try {
      isLoading = true;
      clearError();
      final result = await operation();
      return result;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
    }
  }
}
```

### 2. AuthViewModel

Handle authentication logic:

```dart
class AuthViewModel extends BaseViewModel {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _hasCompletedOnboarding = false;

  // Sign in
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
        await checkOnboardingStatus();
        return true;
      }
      return false;
    }) ?? false;
  }
}
```

### 3. View menggunakan Consumer

```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return Scaffold(
          body: Column(
            children: [
              // TextField email & password
              ElevatedButton(
                onPressed: authViewModel.isLoading 
                  ? null 
                  : () => _handleLogin(authViewModel),
                child: authViewModel.isLoading
                  ? CircularProgressIndicator()
                  : Text('Login'),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### 4. Setup Provider di main.dart

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MyApp(),
    ),
  );
}
```

## 🎯 Keuntungan MVVM

### 1. **Separation of Concerns**
- UI terpisah dari business logic
- Mudah di-maintain dan di-test

### 2. **Testability**
- ViewModel bisa di-test tanpa UI
- Mock data mudah diimplementasikan

### 3. **Reusability**
- ViewModel bisa dipakai di multiple screens
- Logic tidak duplikat

### 4. **Reactive UI**
- UI otomatis update saat state berubah
- Menggunakan `notifyListeners()`

### 5. **Clean Code**
- Screen jadi lebih ringan
- Business logic terpusat di ViewModel

## 📝 Cara Menggunakan

### Membuat ViewModel Baru

```dart
class MyViewModel extends BaseViewModel {
  // State
  List<Data> _data = [];
  List<Data> get data => _data;

  // Method
  Future<void> loadData() async {
    await runWithLoading(() async {
      _data = await MyService.fetchData();
      notifyListeners();
    });
  }
}
```

### Menggunakan di View

```dart
// Cara 1: Consumer (rebuild widget ketika state berubah)
Consumer<MyViewModel>(
  builder: (context, viewModel, child) {
    return Text(viewModel.data.length.toString());
  },
)

// Cara 2: Provider.of (untuk call method tanpa rebuild)
final viewModel = Provider.of<MyViewModel>(context, listen: false);
viewModel.loadData();

// Cara 3: context.read (shorthand dari Provider.of listen: false)
context.read<MyViewModel>().loadData();

// Cara 4: context.watch (shorthand dari Provider.of listen: true)
final data = context.watch<MyViewModel>().data;
```

## 🔥 Best Practices

1. **Jangan akses Service langsung dari View**
   - ❌ `await AuthService().signIn()` di Screen
   - ✅ `await authViewModel.signIn()` lewat ViewModel

2. **Gunakan Consumer untuk data yang sering berubah**
   - Loading state, data list, error messages

3. **Gunakan context.read untuk event handler**
   - Button onPressed, onTap, dll

4. **Gunakan runWithLoading untuk async operations**
   - Otomatis handle loading state dan error

5. **Selalu dispose ViewModel**
   - Provider otomatis dispose saat widget di-remove

## 🚀 Next Steps

Untuk screen lain yang belum di-refactor:
1. Buat ViewModel untuk screen tersebut
2. Pindahkan business logic ke ViewModel
3. Update Screen untuk menggunakan Consumer
4. Register ViewModel di main.dart MultiProvider

## 📚 References

- [Provider Documentation](https://pub.dev/packages/provider)
- [MVVM Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
- [Flutter State Management](https://docs.flutter.dev/development/data-and-backend/state-mgmt)
