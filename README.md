# Infoin - Aplikasi Berita Modern

Aplikasi berita berbasis Flutter dengan Material 3 Design yang menampilkan berita terkini dengan UI yang modern dan intuitif.

## 🚀 Fitur

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

## 📁 Struktur Folder

```
lib/
├── data/
│   └── dummy_data.dart          # Data dummy untuk berita dan chat
├── models/
│   ├── news_model.dart          # Model untuk artikel berita
│   ├── chat_model.dart          # Model untuk pesan chat
│   └── category_model.dart      # Model untuk kategori
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart    # Halaman login
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
│   └── main_screen.dart         # Main screen dengan BottomNavigationBar
├── widgets/
│   └── news_card.dart           # Widget untuk kartu berita
└── main.dart                    # Entry point aplikasi
```

## 🎨 Tema & Design

- **Material 3 Design System**
- **Warna Utama**: Teal (#0097A7)
- **Layout**: Modern dengan rounded corners dan elevation
- **Typography**: Material Design typography scale

## 🔧 Tech Stack

- **Framework**: Flutter
- **Design**: Material 3
- **State Management**: StatefulWidget (untuk demo)
- **Data**: Dummy data (tidak ada backend/API)

## 📱 Cara Menjalankan

1. Pastikan Flutter sudah terinstall
2. Clone repository ini
3. Jalankan command:

```bash
flutter pub get
flutter run
```

## 🎯 Catatan Penting

- **Ini adalah UI/Frontend Only**: Tidak ada koneksi backend, API, atau autentikasi real
- **Data Dummy**: Semua data berita dan chat adalah placeholder
- **Navigasi**: Semua navigasi sudah diimplementasi dengan baik
- **Gemini AI**: Interface chat sudah ada, tapi belum terintegrasi dengan API Gemini

## 🚧 Untuk Pengembangan Selanjutnya

1. Integrasi dengan News API untuk berita real
2. Implementasi autentikasi Firebase
3. Integrasi Gemini AI untuk chat
4. State management dengan Provider/Riverpod/Bloc
5. Local storage dengan SharedPreferences/Hive
6. Implementasi refresh dan pagination

## 📸 Screenshot

Aplikasi menampilkan:
- Login & Register dengan UI modern
- Onboarding 3 langkah
- Bottom Navigation dengan 4 tab
- News cards dengan gambar placeholder
- Chat interface dengan bubble chat
- Profile dengan menu lengkap

## 👨‍💻 Developer

Aplikasi ini dibuat sebagai demo UI/Frontend untuk aplikasi berita modern.

---

**Versi**: 1.0.0  
**Flutter SDK**: ^3.9.2
