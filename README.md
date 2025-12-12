# Pemrograman Mobile - Aplikasi Flutter - Infoin

![INFOIN](https://github.com/Nadzare/infoin-flutter/blob/main/lib/images/logo/infoin.png?raw=true)

![INFOIN](https://img.shields.io/badge/INFOIN-NEWS%20APP-blue?style=for-the-badge&logo=news&logoColor=white)
![MOBILE APP](https://img.shields.io/badge/MOBILE-APP-orange?style=for-the-badge&logo=mobile&logoColor=white)
![FLUTTER](https://img.shields.io/badge/FLUTTER-3.9.2-blue?style=for-the-badge&logo=flutter&logoColor=white)
![DART](https://img.shields.io/badge/DART-3.9.2-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## 📱 Infoin Mobile App

Aplikasi mobile berbasis **Flutter** dan **Dart** yang berfungsi sebagai platform berita dan informasi terkini dengan sistem manajemen konten yang lengkap dan modern menggunakan arsitektur **MVVM (Model-View-ViewModel)**.

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-blue?logo=dart)
![Provider](https://img.shields.io/badge/Provider-6.1.2-green?logo=flutter)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-orange)
![Supabase](https://img.shields.io/badge/Supabase-2.8.0-3ECF8E?logo=supabase)

---

## 🎓 Informasi Mahasiswa

| Atribut | Keterangan |
|---------|------------|
| 👤 **Nama** | [Nama Lengkap Anda] |
| 🆔 **NIM** | [NIM Anda] |
| 📚 **Shift** | [Shift/Kelas Anda] |
| 📖 **Mata Kuliah** | Pemrograman Mobile |

---

## 📖 Deskripsi Sistem

**Infoin** adalah aplikasi mobile cross-platform yang dikembangkan menggunakan **Flutter Framework** dengan bahasa pemrograman **Dart**. Aplikasi ini dirancang sebagai platform berita dan informasi digital yang komprehensif dengan fitur-fitur modern seperti:

### 🎯 Tujuan Aplikasi
- Menyediakan platform berita terpercaya dengan sumber berita terverifikasi
- Memberikan pengalaman membaca berita yang personal dan menyenangkan
- Mengintegrasikan AI (Gemini) untuk asisten berita cerdas
- Memfasilitasi user-generated content melalui Community News
- Menyajikan berita real-time dengan notifikasi push

### 💡 Fitur Unggulan
✅ **Multi-source News Aggregation** - Mengumpulkan berita dari berbagai sumber terpercaya  
✅ **AI-Powered Chat Assistant** - Gemini AI untuk diskusi berita dan fact-checking  
✅ **Community News Platform** - User dapat membuat dan berbagi berita  
✅ **Personalized News Feed** - Konten disesuaikan dengan preferensi user  
✅ **Real-time Notifications** - Update berita penting langsung ke device  
✅ **Multi-platform Support** - Berjalan di Android, iOS, dan Web  

### 🔐 Sistem Autentikasi
- **Email/Password Authentication** - Pendaftaran dan login tradisional
- **Google OAuth 2.0** - Single Sign-On dengan akun Google
- **Session Management** - Token-based authentication dengan Supabase
- **Profile Management** - Pengelolaan data profil dan preferensi user

### 🗄️ Database & Backend
- **Supabase PostgreSQL** - Relational database untuk data terstruktur
- **Real-time Subscriptions** - Live updates untuk chat dan notifications
- **Row Level Security** - Keamanan data level baris
- **Cloud Storage** - Penyimpanan gambar dan media

---

## 🏗️ Arsitektur Sistem

Aplikasi **Infoin** dibangun menggunakan **MVVM (Model-View-ViewModel) Architecture Pattern** dengan **Provider** sebagai state management untuk memastikan separation of concerns, testability, dan maintainability kode.

### 📐 Diagram Arsitektur MVVM

```
┌────────────────────────────────────────────────────────────────┐
│                      🎨 VIEW LAYER (UI)                        │
│                    (Presentation Layer)                        │
├────────────────────────────────────────────────────────────────┤
│  • LoginScreen.dart        • ExploreScreen.dart                │
│  • HomeScreen.dart         • ProfileScreen.dart                │
│  • ChatScreen.dart         • NewsDetailScreen.dart             │
│                                                                 │
│  📌 Responsibilities:                                          │
│    - Render UI components                                      │
│    - Handle user interactions (tap, scroll, input)             │
│    - Listen to ViewModel state changes (Consumer<T>)           │
│    - No business logic                                         │
└────────────────────┬───────────────────────────────────────────┘
                     │
                     │ Consumer<ViewModel> / Provider.of<T>()
                     │ • Reactive binding
                     │ • Auto UI rebuild on state change
                     ▼
┌────────────────────────────────────────────────────────────────┐
│              🧠 VIEWMODEL LAYER (Business Logic)               │
│                  (Presentation Logic Layer)                    │
├────────────────────────────────────────────────────────────────┤
│  • BaseViewModel.dart      • AuthViewModel.dart                │
│  • HomeViewModel.dart      • ChatViewModel.dart                │
│  • NewsViewModel.dart      • ProfileViewModel.dart             │
│                                                                 │
│  📌 Responsibilities:                                          │
│    - State management (isLoading, errorMessage)                │
│    - Business logic (validation, data transformation)          │
│    - Call Service layer methods                                │
│    - Notify View of state changes (notifyListeners)            │
│    - NO direct UI or database access                           │
│                                                                 │
│  📦 State Properties:                                          │
│    • bool isLoading                                            │
│    • String? errorMessage                                      │
│    • List<News> newsList                                       │
│    • User? currentUser                                         │
└────────────────────┬───────────────────────────────────────────┘
                     │
                     │ Method calls (async/await)
                     │ • authService.signIn()
                     │ • newsService.fetchNews()
                     ▼
┌────────────────────────────────────────────────────────────────┐
│           🔌 SERVICE LAYER (Data Access)                       │
│              (Business Logic Layer)                            │
├────────────────────────────────────────────────────────────────┤
│  • AuthService.dart           • NewsService.dart               │
│  • CommunityNewsService.dart  • CountryService.dart            │
│  • GeminiService.dart         • NotificationService.dart       │
│                                                                 │
│  📌 Responsibilities:                                          │
│    - API calls to Supabase                                     │
│    - Database CRUD operations                                  │
│    - External API integrations (Google, Gemini)                │
│    - Error handling & logging                                  │
│    - Data validation before save                               │
│    - Response parsing                                          │
│                                                                 │
│  📡 Operations:                                                │
│    • Authentication (login, register, OAuth)                   │
│    • Data fetching (read)                                      │
│    • Data mutation (create, update, delete)                    │
│    • Real-time subscriptions                                   │
└────────────────────┬───────────────────────────────────────────┘
                     │
                     │ HTTP/REST API calls
                     │ • POST /auth/signup
                     │ • GET /rest/v1/news
                     ▼
┌────────────────────────────────────────────────────────────────┐
│           ☁️ BACKEND (Supabase BaaS)                          │
│                                                                 │
│  • PostgreSQL Database                                         │
│  • Authentication Service                                      │
│  • Storage Service                                             │
│  • Real-time Engine                                            │
└────────────────────┬───────────────────────────────────────────┘
                     │
                     │ Database queries & responses
                     ▼
┌────────────────────────────────────────────────────────────────┐
│             📦 MODEL LAYER (Data Structures)                   │
│                   (Domain Layer)                               │
├────────────────────────────────────────────────────────────────┤
│  • NewsModel.dart           • ArticleModel.dart                │
│  • UserProfile.dart         • ChatModel.dart                   │
│  • CategoryModel.dart       • CommentModel.dart                │
│  • CountryModel.dart        • NotificationModel.dart           │
│                                                                 │
│  📌 Responsibilities:                                          │
│    - Data representation (Dart classes)                        │
│    - JSON serialization (toJson)                               │
│    - JSON deserialization (fromJson)                           │
│    - Data validation                                           │
│    - Type safety                                               │
│                                                                 │
│  📋 Structure:                                                 │
│    class NewsModel {                                           │
│      final String id;                                          │
│      final String title;                                       │
│      final DateTime publishedAt;                               │
│      NewsModel.fromJson(Map<String, dynamic> json) {...}       │
│      Map<String, dynamic> toJson() {...}                       │
│    }                                                            │
└────────────────────────────────────────────────────────────────┘
```

### 🔄 Data Flow dalam Aplikasi

#### 1️⃣ User Interaction Flow (Read Operation)
```
User tap "Refresh News"
    ↓
View: HomeScreen.build()
    ↓ onRefresh()
ViewModel: homeViewModel.loadNews()
    ↓ set isLoading = true, notifyListeners()
View: Show loading indicator
    ↓
ViewModel: await newsService.fetchNews()
    ↓
Service: Supabase.from('news').select()
    ↓
Backend: Query database → Return JSON
    ↓
Service: Parse JSON → List<NewsModel>
    ↓
ViewModel: newsList = result, isLoading = false, notifyListeners()
    ↓
View: Rebuild with new data → Show news list
```

#### 2️⃣ User Action Flow (Write Operation)
```
User tap "Login" button
    ↓
View: LoginScreen - _handleLogin()
    ↓ authViewModel.signIn(email, password)
ViewModel: Validate input → call authService
    ↓ set isLoading = true, notifyListeners()
View: Show loading spinner
    ↓
Service: authService.signIn(email, password)
    ↓ Supabase.auth.signInWithPassword()
Backend: Verify credentials → Return session
    ↓
Service: ensureProfileExists() → Return User
    ↓
ViewModel: Update currentUser, isLoading = false
    ↓ notifyListeners()
View: Navigate to HomeScreen
```

### 🧩 Komponen Arsitektur Detail

#### 1️⃣ **MODEL LAYER** 📦
**Lokasi**: `lib/models/`

**Fungsi**:
- Pure Dart classes untuk representasi data
- Immutable data objects (menggunakan `final`)
- Type-safe data structures
- JSON serialization/deserialization

**Contoh Implementation**:
```dart
class NewsModel {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime publishedAt;
  final String sourceId;
  
  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.publishedAt,
    required this.sourceId,
  });
  
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['image_url'],
      publishedAt: DateTime.parse(json['published_at']),
      sourceId: json['source_id'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'published_at': publishedAt.toIso8601String(),
      'source_id': sourceId,
    };
  }
}
```

#### 2️⃣ **VIEW LAYER** 🎨
**Lokasi**: `lib/screens/`, `lib/widgets/`

**Fungsi**:
- Stateless/Stateful Widgets
- UI rendering dengan Material Design
- User interaction handling
- Consume ViewModel state dengan Provider

**Contoh Implementation**:
```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return Scaffold(
          body: authViewModel.isLoading
            ? CircularProgressIndicator()
            : LoginForm(
                onSubmit: (email, password) {
                  authViewModel.signIn(email, password);
                },
              ),
        );
      },
    );
  }
}
```

#### 3️⃣ **VIEWMODEL LAYER** 🧠
**Lokasi**: `lib/viewmodels/`

**Fungsi**:
- Extends `ChangeNotifier` dari Provider
- State management (loading, error, data)
- Business logic processing
- Coordination dengan Service layer

**Contoh Implementation**:
```dart
class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  User? _currentUser;
  User? get currentUser => _currentUser;
  
  AuthViewModel(this._authService);
  
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _currentUser = await _authService.signIn(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
```

#### 4️⃣ **SERVICE LAYER** 🔌
**Lokasi**: `lib/services/`

**Fungsi**:
- Singleton pattern untuk shared instances
- API integration dengan Supabase
- CRUD operations
- Error handling & retry logic

**Contoh Implementation**:
```dart
class AuthService {
  final SupabaseClient _supabase;
  
  AuthService(this._supabase);
  
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Login failed');
      }
      
      await ensureProfileExists(response.user!);
      return response.user!;
    } catch (e) {
      throw Exception('Sign in error: $e');
    }
  }
}
```

### ⚡ State Management dengan Provider

**Setup di main.dart**:
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (context) => AuthViewModel(AuthService(supabase)),
    ),
    ChangeNotifierProvider(
      create: (context) => HomeViewModel(
        NewsService(supabase),
        CommunityNewsService(supabase),
        AuthService(supabase),
      ),
    ),
  ],
  child: MaterialApp(...),
)
```

**Konsumsi di Widget**:
```dart
// Method 1: Consumer (recommended for selective rebuild)
Consumer<AuthViewModel>(
  builder: (context, authViewModel, child) {
    return Text(authViewModel.currentUser?.name ?? 'Guest');
  },
)

// Method 2: Provider.of (rebuild seluruh widget)
final authViewModel = Provider.of<AuthViewModel>(context);

// Method 3: context.watch (Dart 2.12+)
final authViewModel = context.watch<AuthViewModel>();

// Method 4: context.read (untuk actions, tidak rebuild)
context.read<AuthViewModel>().signIn(email, password);
```

### ✅ Keuntungan Arsitektur MVVM

| Aspek | Keuntungan | Penjelasan |
|-------|------------|------------|
| 🎯 **Separation of Concerns** | Clear responsibility | Setiap layer punya tugas spesifik |
| 🧪 **Testability** | Easy unit testing | ViewModel & Service testable tanpa UI |
| ♻️ **Reusability** | DRY principle | ViewModel bisa dipakai multiple screens |
| 🔧 **Maintainability** | Easy to modify | Perubahan di satu layer tidak affect others |
| 📈 **Scalability** | Easy to extend | Tambah fitur baru tanpa refactor massive |
| 👥 **Team Collaboration** | Parallel development | Frontend & backend dev bisa kerja paralel |
| 🐛 **Debugging** | Isolated issues | Bug mudah ditemukan karena layer terpisah |
| 🔄 **Reactive UI** | Auto update | UI otomatis sync dengan data changes |

### 🎯 Best Practices yang Diterapkan

✅ **Single Responsibility Principle** - Setiap class punya satu tugas  
✅ **Dependency Injection** - Dependencies di-inject via constructor  
✅ **Separation of Concerns** - UI, logic, dan data access terpisah  
✅ **Immutable Models** - Data models menggunakan `final` properties  
✅ **Async/Await Pattern** - Untuk non-blocking operations  
✅ **Error Handling** - Try-catch di setiap async operation  
✅ **Loading States** - User feedback untuk setiap action  
✅ **Code Documentation** - Doc comments untuk setiap public method  

---

## 🚀 Fitur Aplikasi

### ✅ 1. Autentikasi & Manajemen Akun

#### 🔐 Login System
- **Email/Password Authentication**
  - Form validasi dengan error handling
  - Password visibility toggle
  - Loading indicator saat proses login
  - Error messages yang informatif
  
- **Google OAuth 2.0 Integration**
  - Single Sign-On dengan Google account
  - Auto profile creation dari Google data
  - Redirect URI handling untuk web platform
  - Native Google Sign-In untuk mobile

#### 📝 Register System
- Form pendaftaran dengan validasi
- Password strength indicator
- Email verification
- Auto login setelah registrasi berhasil

#### 👤 Profile Management
- Update nama dan bio
- Upload foto profil
- Kelola preferensi berita
- Logout functionality

### ✅ 2. Onboarding Experience (3 Steps)

#### Step 1: 🌍 Country Selection
- Grid view dengan bendera negara
- Search functionality
- Popular countries di atas
- Multi-language support

#### Step 2: 📚 Topic Selection
- Choice chips untuk kategori
- Multiple selection
- Visual feedback saat dipilih
- Minimum 3 topik harus dipilih

#### Step 3: 📰 Source Selection
- List sumber berita terpercaya
- Logo dan deskripsi setiap sumber
- Toggle selection
- Preview sebelum selesai

### ✅ 3. Aplikasi Utama (4 Tab Navigation)

#### 🏠 Tab Home (Beranda)
**Fitur**:
- Personalized news feed
- Pull-to-refresh
- Infinite scroll pagination
- Category filter chips
- Trending news section
- Breaking news banner

**UI Components**:
- Greeting header dengan nama user
- News cards dengan:
  - Featured image
  - Title & description
  - Source logo & name
  - Published time (relative)
  - Category badge
  - Bookmark button
  - Share button

**Data Source**:
- API dari Supabase
- Real-time updates
- Cache untuk offline mode

#### 🔍 Tab Explore (Jelajah)
**Fitur**:
- Search bar dengan autocomplete
- Category grid (8 categories):
  - Politik 🏛️
  - Ekonomi 💰
  - Teknologi 💻
  - Olahraga ⚽
  - Entertainment 🎬
  - Kesehatan 🏥
  - Pendidikan 📚
  - Sains 🔬
- Trending topics
- Popular news

**UI Components**:
- Search dengan debouncing
- Category cards dengan gradient
- Trending news carousel
- Filter dan sort options

#### 💬 Tab Chat AI (Gemini Assistant)
**Fitur**:
- AI-powered conversation dengan Gemini
- Context-aware responses
- News fact-checking
- Article summarization
- Topic recommendations

**UI Components**:
- Chat bubbles (user & AI)
- Typing indicator
- Message timestamps
- Copy response button
- Regenerate response
- Clear chat history

**Capabilities**:
- Diskusi berita terkini
- Fact-checking informasi
- Summarize artikel panjang
- Rekomendasi topik menarik
- Q&A tentang berita

#### 👤 Tab Profile
**Fitur**:
- User profile display
- Account settings
- News preferences
- Notification settings
- Saved articles
- Reading history
- Logout

**Menu Items**:
- 👤 Edit Profile
- 🔔 Notifications Settings
- 📰 News Preferences
- 🌍 Change Country
- 📚 Change Topics
- 📰 Change Sources
- 🌙 Dark Mode Toggle
- ℹ️ About App
- 🚪 Logout

### ✅ 4. Community News Platform

#### ✍️ Create News
**Fitur**:
- Rich text editor
- Image upload dengan preview
- Category selection
- Tags untuk SEO
- Draft saving
- Publish atau schedule

**Form Fields**:
- Title (required)
- Content (rich text editor)
- Featured image
- Category dropdown
- Tags (comma separated)
- Source URL (optional)

#### 📖 View Community News
- Grid/List view toggle
- Filter by category
- Sort by date/popularity
- User attribution
- Like & comment count
- Share functionality

#### 💬 Comments & Interactions
- Add comments
- Like/unlike news
- Reply to comments
- Report inappropriate content

### ✅ 5. News Detail & WebView

#### 📰 News Detail Screen
- Full article content
- Related news section
- Comment section
- Share options
- Bookmark toggle

#### 🌐 WebView Integration
- In-app browser untuk artikel eksternal
- Progress indicator
- Refresh button
- Forward/backward navigation
- Open in external browser option

### ✅ 6. Notifications System

#### 🔔 Push Notifications
- Breaking news alerts
- Personalized news recommendations
- Community news dari followed topics
- Comment replies notification

#### 📱 Notification Screen
- List semua notifications
- Mark as read/unread
- Delete notification
- Navigate to related content
- Filter by type

### ✅ 7. Additional Features

#### 🔍 Search Functionality
- Global search across all news
- Search history
- Popular searches
- Filter results by:
  - Date range
  - Category
  - Source
  - Relevance

#### 📥 Offline Mode
- Cache news untuk offline reading
- Queue actions untuk sync later
- Offline indicator
- Auto sync when online

#### 🎨 UI/UX Features
- Material 3 Design System
- Blue gradient color scheme
- Smooth animations
- Loading skeletons
- Empty states
- Error states dengan retry
- Success/Error snackbars
- Bottom sheets untuk options
- Dialogs untuk confirmations

---

### ✅ Autentikasi (UI Only)
- **Login Screen**: Form login dengan email/password dan tombol Google Sign In
- **Register Screen**: Form pendaftaran pengguna baru

### ✅ Onboarding (3 Step)
- **Step 1**: Pilih Negara - Memilih negara untuk berita yang relevan
- **Step 2**: Pilih Topik - Memilih topik favorit menggunakan Choice Chips
- **Step 3**: Pilih Sumber - Memilih sumber berita terpercaya

### ✅ Aplikasi Utama (4 Tab)

#### 🏠 Tab Beranda (Home)
- Sapaan pengguna
- ListView dengan News Cards
- Menampilkan: gambar, judul, deskripsi, sumber, dan waktu publikasi

#### 🔍 Tab Explore
- Search Bar untuk pencarian berita
- GridView kategori berita (8 kategori)
- Section berita trending

#### 💬 Tab Chat AI
- Interface chat dengan Gemini AI
- Chat bubbles untuk percakapan
- Input field dan tombol kirim
- Data dummy untuk demo

#### 👤 Tab Profile
- Header dengan foto profil dan nama
- Menu pengaturan akun
- Menu preferensi berita
- Tombol logout

## 📁 Struktur Folder (MVVM Architecture)

```
lib/
├── main.dart                    # Entry point dengan MultiProvider setup
├── data/
│   └── dummy_data.dart          # Data dummy untuk berita dan chat
├── models/                      # 📦 MODEL LAYER
│   ├── article_model.dart       # Model untuk artikel berita
│   ├── news_model.dart          # Model untuk berita
│   ├── chat_model.dart          # Model untuk pesan chat
│   ├── category_model.dart      # Model untuk kategori
│   ├── comment_model.dart       # Model untuk komentar
│   ├── community_news_model.dart # Model untuk berita komunitas
│   ├── country_model.dart       # Model untuk negara
│   ├── news_source_model.dart   # Model untuk sumber berita
│   └── notification_model.dart  # Model untuk notifikasi
├── viewmodels/                  # 🧠 VIEWMODEL LAYER (Business Logic)
│   ├── base_viewmodel.dart      # Base class untuk semua ViewModel
│   ├── auth_viewmodel.dart      # ViewModel untuk autentikasi
│   └── home_viewmodel.dart      # ViewModel untuk home screen
├── services/                    # 🔌 SERVICE LAYER (Data Access)
│   ├── auth_service.dart        # Service untuk autentikasi Supabase
│   ├── news_service.dart        # Service untuk operasi berita
│   ├── community_news_service.dart # Service untuk berita komunitas
│   ├── country_service.dart     # Service untuk data negara
│   └── gemini_service.dart      # Service untuk Gemini AI
├── screens/                     # 🎨 VIEW LAYER (Presentation)
│   ├── auth/
│   │   ├── login_screen.dart    # Halaman login (MVVM)
│   │   └── register_screen.dart # Halaman register
│   ├── onboarding/
│   │   ├── country_selection_screen.dart  # Step 1: Pilih negara
│   │   ├── topic_selection_screen.dart    # Step 2: Pilih topik
│   │   └── source_selection_screen.dart   # Step 3: Pilih sumber
│   ├── tabs/
│   │   ├── home_screen.dart     # Tab Beranda
│   │   ├── explore_screen.dart  # Tab Explore
│   │   ├── chat_screen.dart     # Tab Chat AI
│   │   └── profile_screen.dart  # Tab Profile
│   ├── main_screen.dart         # Main screen dengan BottomNavigationBar
│   ├── splash_screen.dart       # Splash screen
│   ├── community_news_detail_screen.dart
│   ├── create_news_screen.dart
│   ├── news_detail_webview.dart
│   ├── notifications_screen.dart
│   ├── select_source_screen.dart
│   └── settings_screen.dart
└── widgets/                     # 🧩 REUSABLE COMPONENTS
    ├── news_card.dart           # Widget untuk kartu berita
    └── ...                      # Widget lainnya
```

### Penjelasan Layer dalam Struktur:

**📦 Model Layer** (`/models`)
- Pure Dart classes tanpa dependencies
- Representasi data dari API/Database
- JSON serialization/deserialization

**🧠 ViewModel Layer** (`/viewmodels`)
- Extends `ChangeNotifier`
- Mengelola state dan business logic
- Bridge antara View dan Service

**🔌 Service Layer** (`/services`)
- API calls ke Supabase
- Database operations
- External integrations (Google Sign-In, Gemini AI)

**🎨 View Layer** (`/screens` & `/widgets`)
- StatelessWidget atau StatefulWidget
- Menggunakan `Consumer<T>` atau `Provider.of<T>`
- Hanya fokus pada UI rendering

---

## 🎨 Tema & Design

- **Material 3 Design System**
- **Warna Utama**: Teal (#0097A7)
- **Layout**: Modern dengan rounded corners dan elevation
- **Typography**: Material Design typography scale

## 🔧 Tech Stack

### Frontend Framework
- **Flutter** ^3.9.2 - Cross-platform UI framework
- **Dart** - Programming language

### Architecture & State Management
- **MVVM Pattern** - Separation of concerns
- **Provider** ^6.1.2 - State management dan dependency injection
- **ChangeNotifier** - Reactive state updates

### Backend & Database
- **Supabase** ^2.8.0 - Backend as a Service
  - Authentication (Email/Password, Google OAuth)
  - PostgreSQL Database
  - Real-time subscriptions
  - Storage

### UI & Design
- **Material 3 Design System** - Modern design language
- **Custom Color Scheme** - Blue gradient palette (Blue, Indigo, Cyan)
- **Responsive Layout** - Adaptive untuk berbagai screen sizes

### Third-Party Integrations
- **Google Sign-In** ^6.2.1 - OAuth authentication
- **Gemini AI** - AI-powered chat assistant
- **WebView** ^4.11.0 - In-app browser untuk artikel
- **Image Picker** ^1.2.0 - Upload gambar
- **Shared Preferences** ^2.5.3 - Local storage

### Development Tools
- **Flutter DevTools** - Debugging dan profiling
- **Dart Analyzer** - Static code analysis
- **Flutter Lints** - Code quality rules

---

## 📱 Cara Menjalankan

### Prerequisites
- Flutter SDK >= 3.9.2
- Dart SDK >= 3.9.2
- Android Studio / VS Code dengan Flutter extension
- Chrome (untuk web development)

### Langkah Instalasi

1. **Clone Repository**
```bash
git clone <repository-url>
cd infoin
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Setup Environment Variables**
   - Buat file `.env` atau konfigurasi Supabase
   - Tambahkan Supabase URL dan API keys
   - Setup Google OAuth credentials

4. **Run Application**

**Untuk Web (Development):**
```bash
flutter run -d chrome --web-port 54980
```

**Untuk Android:**
```bash
flutter run -d <device-id>
```

**Untuk iOS:**
```bash
flutter run -d <ios-device-id>
```

5. **Build for Production**

**Web:**
```bash
flutter build web
```

**Android APK:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## 🎯 Status Implementasi

### ✅ Completed Features
- [x] MVVM Architecture dengan Provider
- [x] Autentikasi (Email/Password & Google Sign-In)
- [x] Supabase Integration (Auth & Database)
- [x] Onboarding Flow (3 steps)
- [x] Home Screen dengan News Feed
- [x] Explore Screen dengan Categories
- [x] Chat Screen dengan Gemini AI
- [x] Profile Screen dengan Settings
- [x] Community News (Create & View)
- [x] WebView untuk artikel detail
- [x] Notifications
- [x] Blue Gradient UI Theme
- [x] Responsive Design

### 🚧 In Progress
- [ ] HomeScreen refactoring dengan MVVM
- [ ] Offline mode dengan local caching
- [ ] Unit tests untuk ViewModels
- [ ] Widget tests untuk UI components

### 📋 Future Enhancements
- [ ] Dark mode support
- [ ] Multi-language (i18n)
- [ ] Push notifications
- [ ] Advanced search filters
- [ ] Bookmark/Save articles
- [ ] Share functionality
- [ ] Performance optimization
- [ ] Accessibility improvements
- [ ] Analytics integration

---

## 📐 Design Patterns yang Digunakan

### 1. **MVVM (Model-View-ViewModel)**
Separation of concerns untuk maintainability

### 2. **Repository Pattern**
Service layer sebagai abstraction untuk data access

### 3. **Dependency Injection**
Provider untuk inject dependencies di root app

### 4. **Observer Pattern**
ChangeNotifier dan Consumer untuk reactive UI

### 5. **Factory Pattern**
Model classes dengan factory constructors untuk JSON parsing

### 6. **Singleton Pattern**
Service classes untuk shared instances

---

## 🔐 Security & Best Practices

✅ Environment variables untuk sensitive data  
✅ Secure storage untuk authentication tokens  
✅ Input validation di ViewModel layer  
✅ Error handling di semua async operations  
✅ Loading states untuk better UX  
✅ Null safety dengan Dart 3.0  
✅ Code formatting dengan `dart format`  
✅ Linting dengan Flutter recommended rules  

---

## 📸 Screenshots

### Authentication Flow
- **Login Screen** - Modern login dengan email/password dan Google Sign-In
- **Register Screen** - Pendaftaran user baru dengan validasi

### Onboarding Experience
- **Step 1** - Country Selection dengan flag icons
- **Step 2** - Topic Selection dengan choice chips
- **Step 3** - Source Selection dengan media logos

### Main Application
- **Home Tab** - News feed dengan blue gradient cards
- **Explore Tab** - Category grid dan trending news
- **Chat Tab** - AI-powered chat dengan Gemini
- **Profile Tab** - User profile dan settings

### Special Features
- **Community News** - User-generated content
- **News Detail** - WebView untuk artikel lengkap
- **Notifications** - Real-time updates
- **Create News** - Form untuk publish berita

---

## 🧪 Testing

### Running Tests

**Unit Tests:**
```bash
flutter test
```

**Widget Tests:**
```bash
flutter test --coverage
```

**Integration Tests:**
```bash
flutter drive --target=test_driver/app.dart
```

### Test Coverage
Target: 80% code coverage untuk critical business logic

---

## 📚 Documentation

### Dokumentasi Tambahan
- `ANDROID_TESTING_GUIDE.md` - Panduan testing untuk Android
- `GEMINI_API_UPDATES.md` - Update integrasi Gemini AI
- `GOOGLE_SIGNIN_SETUP.md` - Setup Google Sign-In

### Code Documentation
- Setiap ViewModel memiliki doc comments
- Service methods terdokumentasi dengan parameter dan return types
- Model classes dengan property descriptions

---

## 🤝 Contributing

### Development Guidelines
1. Follow MVVM architecture pattern
2. Use Provider untuk state management
3. Write meaningful commit messages
4. Add tests untuk new features
5. Update README untuk changes
6. Follow Dart/Flutter style guide

### Code Style
```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Run linter
dart fix --apply
```

---

## 📄 License

Aplikasi ini dibuat untuk keperluan edukasi Mata Kuliah Pemrograman Mobile.

---

## 👨‍💻 Developer

**Nama Lengkap** - [NIM]  
Universitas - Program Studi  
Mata Kuliah: Pemrograman Mobile

### Contact
📧 Email: [email@example.com]  
🔗 GitHub: [github.com/username]  
💼 LinkedIn: [linkedin.com/in/username]

---

## 🙏 Acknowledgments

- Flutter Team untuk framework yang amazing
- Supabase untuk BaaS platform
- Google untuk Material Design dan Gemini AI
- Community untuk packages dan tutorials

---

<div align="center">
  <strong>Made with ❤️ using Flutter</strong>
  
  **Infoin - Stay Informed, Stay Ahead**
  
  ⭐ Star this repo if you find it helpful!
</div>

---

**Versi**: 1.0.0  
**Last Updated**: Desember 2025  
**Flutter SDK**: ^3.9.2  
**Dart SDK**: ^3.9.2

