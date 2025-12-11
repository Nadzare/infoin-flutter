# 🔐 Panduan Setup Google Sign-In untuk Infoin

Dokumen ini menjelaskan cara mengkonfigurasi Google Sign-In untuk aplikasi Infoin (Web & Android).

---

## 🎯 Cara Kerja

### Hybrid Approach (Web vs Mobile)

**Web Platform:**
- Menggunakan **Supabase OAuth** (`signInWithOAuth`)
- Browser akan **redirect** ke halaman Google login
- Setelah berhasil, redirect kembali ke `http://localhost:5000`
- Auth state listener menangkap session dan navigate otomatis

**Mobile/Android Platform:**
- Menggunakan **Native Google Sign-In** (`google_sign_in` package)
- Dialog native Android muncul
- Menggunakan ID Token untuk authenticate ke Supabase
- Auto-create profile untuk user baru

---

## 📋 Prerequisites

- Akun Google Cloud Platform (GCP)
- Akun Supabase
- Project Flutter Infoin sudah disetup

---

## 1️⃣ Setup Google Cloud Console

### Langkah 1: Buat/Pilih Project

1. Buka [Google Cloud Console](https://console.cloud.google.com/)
2. Klik dropdown project di header (atau klik **Select a project**)
3. Klik **NEW PROJECT** atau pilih project yang sudah ada
4. Beri nama: `Infoin` (atau nama lain sesuai keinginan)
5. Klik **CREATE**

---

### Langkah 2: Enable Required APIs (WAJIB)

Google Sign-In membutuhkan beberapa API untuk berfungsi dengan baik:

#### A. Enable People API (WAJIB)
1. Di sidebar, klik **APIs & Services** → **Library**
2. Cari **"Google People API"** atau klik link ini:
   ```
   https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=[PROJECT_NUMBER]
   ```
3. Klik **ENABLE**
4. Tunggu beberapa menit untuk propagasi

#### B. Enable Google+ API (Opsional tapi Direkomendasikan)
1. Di sidebar, klik **APIs & Services** → **Library**
2. Cari **"Google+ API"**
3. Klik **ENABLE**

> ⚠️ **PENTING**: Tanpa People API, Google Sign-In akan gagal dengan error 403!

---

### Langkah 3: Configure OAuth Consent Screen

1. Di sidebar, klik **APIs & Services** → **OAuth consent screen**
2. Pilih **User Type**:
   - **External** (untuk testing dengan akun Google mana pun)
   - Klik **CREATE**

3. **App Information**:
   - App name: `Infoin`
   - User support email: `[email Anda]`
   - Developer contact: `[email Anda]`
   - Klik **SAVE AND CONTINUE**

4. **Scopes** (skip untuk sekarang):
   - Klik **SAVE AND CONTINUE**

5. **Test users** (jika User Type = External):
   - Klik **+ ADD USERS**
   - Masukkan email Google yang akan dipakai testing
   - Klik **SAVE AND CONTINUE**

6. **Summary**:
   - Review dan klik **BACK TO DASHBOARD**

---

### Langkah 4: Buat OAuth 2.0 Client ID (Web)

1. Di sidebar, klik **APIs & Services** → **Credentials**
2. Klik **+ CREATE CREDENTIALS** → **OAuth client ID**
3. Pilih **Application type**: `Web application`
4. **Name**: `Infoin Web Client`
5. **Authorized JavaScript origins**:
   ```
   http://localhost:5000
   http://localhost
   ```
   > Klik **+ ADD URI** untuk menambah lebih dari satu
   
6. **Authorized redirect URIs** (opsional untuk testing lokal):
   ```
   http://localhost:5000
   ```

7. Klik **CREATE**
8. **Simpan Client ID** yang muncul:
   ```
   Format: xxxxx-xxxxxxx.apps.googleusercontent.com
   ```
   > ⚠️ **PENTING**: Ini adalah **Web Client ID**, bukan Android Client ID!

---

### Langkah 5: Buat OAuth 2.0 Client ID (Android) - Opsional

Jika ingin testing di Android:

1. Klik **+ CREATE CREDENTIALS** → **OAuth client ID**
2. Pilih **Application type**: `Android`
3. **Name**: `Infoin Android Client`
4. **Package name**: `com.example.infoin` (sesuaikan dengan `android/app/build.gradle`)
5. **SHA-1 certificate fingerprint**:
   - Untuk **Debug**:
     ```bash
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
     ```
   - Copy SHA-1 dari output
   
6. Klik **CREATE**

---

## 2️⃣ Setup Supabase

### Langkah 1: Enable Google Provider

1. Buka [Supabase Dashboard](https://supabase.com/dashboard)
2. Pilih project Anda → **Authentication** → **Providers**
3. Cari **Google** dan klik untuk expand
4. Toggle **Enable Sign in with Google**: `ON`

### Langkah 2: Masukkan Credentials

1. **Client ID (for OAuth)**:
   - Paste **Web Client ID** dari Google Cloud Console
   ```
   xxxxx-xxxxxxx.apps.googleusercontent.com
   ```

2. **Client Secret (for OAuth)**:
   - Kembali ke Google Cloud Console → **Credentials**
   - Klik pada **Web Client ID** yang sudah dibuat
   - Copy **Client secret**
   - Paste ke Supabase

3. Klik **Save**

### Langkah 3: Copy Authorized Redirect URIs (Untuk Production)

Di halaman Google Provider Supabase, akan ada **Callback URL (for OAuth)**:
```
https://[PROJECT-ID].supabase.co/auth/v1/callback
```

Tambahkan URL ini ke **Google Cloud Console** → **Credentials** → **Web Client ID** → **Authorized redirect URIs**

---

## 3️⃣ Update Flutter Project

### Langkah 1: Update `auth_service.dart`

Ganti **Web Client ID** di file `lib/services/auth_service.dart`:

```dart
static const String webClientId = 'PASTE_WEB_CLIENT_ID_ANDA_DISINI';
```

**Contoh**:
```dart
static const String webClientId = '123456789-abcdefgh.apps.googleusercontent.com';
```

---

### Langkah 2: Update `web/index.html`

Ganti **Web Client ID** di file `web/index.html`:

```html
<meta name="google-signin-client_id" content="PASTE_WEB_CLIENT_ID_ANDA_DISINI">
```

**Contoh**:
```html
<meta name="google-signin-client_id" content="123456789-abcdefgh.apps.googleusercontent.com">
```

---

## 4️⃣ Testing

### Testing di Web (Chrome)

1. Pastikan sudah menjalankan `flutter pub get`
2. Di VS Code, tekan `F5` atau pilih debug config: **"Infoin Web (Port 5000)"**
3. Aplikasi akan terbuka di `http://localhost:5000`
4. Klik tombol **"Masuk dengan Google"**
5. Pilih akun Google (pastikan akun sudah ditambahkan sebagai Test User)
6. Login seharusnya berhasil

---

### Testing di Android

1. Pastikan sudah setup **Android Client ID** di Google Cloud Console
2. Tambahkan SHA-1 fingerprint
3. Update `android/app/build.gradle` dengan package name yang benar
4. Jalankan:
   ```bash
   flutter run -d <device_id>
   ```

---

## 🔧 Troubleshooting

### Error 403: People API has not been used / PERMISSION_DENIED

**Error Message**:
```
People API has not been used in project [PROJECT_NUMBER] before or it is disabled.
```

**Penyebab**:
- Google People API belum di-enable di project

**Solusi**:
1. Buka link yang ada di error message, atau:
2. Go to: **Google Cloud Console** → **APIs & Services** → **Library**
3. Cari **"Google People API"**
4. Klik **ENABLE**
5. Tunggu 2-5 menit untuk propagasi
6. Restart aplikasi Flutter
7. Coba login Google lagi

> 💡 **Quick Fix**: Buka link ini dan replace `[PROJECT_NUMBER]` dengan project number Anda:
> ```
> https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=[PROJECT_NUMBER]
> ```

---

### Error 401: invalid_client

**Penyebab**:
- Client ID salah atau tidak valid
- Authorized JavaScript origins tidak dikonfigurasi
- Menggunakan Android Client ID untuk Web

**Solusi**:
1. Verifikasi Client ID type = "Web application" di Google Cloud Console
2. Pastikan `http://localhost:5000` ada di Authorized JavaScript origins
3. Tunggu 5-10 menit setelah save configuration (propagasi)
4. Clear browser cache (Ctrl+Shift+Delete)

---

### Error: serverClientId is not supported on Web

**Penyebab**:
- Inisialisasi GoogleSignIn salah untuk platform Web

**Solusi**:
- Pastikan `auth_service.dart` menggunakan `kIsWeb` untuk conditional parameter
- Sudah otomatis dihandle jika mengikuti panduan ini

---

### Google Sign-In Dialog Tidak Muncul

**Solusi**:
1. Cek browser console (F12) untuk error
2. Pastikan meta tag di `index.html` sudah benar
3. Restart aplikasi Flutter (hot restart tidak cukup untuk perubahan HTML)

---

### Warning: "gapi.client library is not loaded"

**Pesan lengkap**:
```
[GSI_LOGGER-TOKEN_CLIENT]: The OAuth token was not passed to gapi.client, 
since the gapi.client library is not loaded in your page.
```

**Penjelasan**:
- Ini adalah **WARNING**, bukan error fatal
- Google Sign-In SDK mencoba men-set token ke gapi.client sebagai convenience feature
- Jika kita tidak menggunakan gapi.client (kita pakai Supabase), warning ini bisa diabaikan
- Login tetap bisa berhasil meskipun ada warning ini

**Solusi (Opsional)**:
Jika ingin menghilangkan warning:
1. Script sudah dimuat synchronously di `index.html` (tanpa async/defer)
2. Pastikan script dimuat dalam urutan yang benar

**PENTING**: Jika tetap gagal login setelah warning ini, masalahnya bukan gapi.client, tapi:
- ID Token null → cek scope "openid" sudah ada
- Access Token null → cek Client ID dan konfigurasi OAuth

---

### Error: "Gagal mendapatkan ID token dari Google"

**Penyebab**:
- Scope "openid" tidak aktif atau tidak dikembalikan oleh Google

**Solusi**:
1. Pastikan GoogleSignIn di `auth_service.dart` sudah include scopes:
   ```dart
   scopes: ['email', 'profile', 'openid']
   ```
2. Cek browser console untuk melihat token mana yang null
3. Pastikan OAuth consent screen sudah include scope yang diperlukan

---

### Redirect ke Halaman Kosong Setelah Login

**Penyebab**:
- Authorized redirect URIs belum dikonfigurasi

**Solusi**:
- Tambahkan `http://localhost:5000` di Authorized redirect URIs
- Untuk production, tambahkan Supabase callback URL

---

## 📚 Referensi

- [Google Sign-In Flutter Package](https://pub.dev/packages/google_sign_in)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [Supabase Google OAuth Setup](https://supabase.com/docs/guides/auth/social-login/auth-google)

---

## ✅ Checklist Setup

Gunakan checklist ini untuk memastikan semua langkah sudah dilakukan:

- [ ] Buat project di Google Cloud Console
- [ ] **Enable Google People API (WAJIB)**
- [ ] Configure OAuth consent screen
- [ ] Buat Web Client ID
- [ ] Copy Web Client ID
- [ ] Enable Google Provider di Supabase
- [ ] Paste Client ID & Secret ke Supabase
- [ ] Update `auth_service.dart` dengan Client ID
- [ ] Update `web/index.html` dengan Client ID
- [ ] Tambahkan `http://localhost:5000` ke Authorized JavaScript origins
- [ ] Tambahkan Test Users (jika External)
- [ ] Testing di Chrome dengan port 5000
- [ ] Berhasil login!

---

**🎉 Selamat! Google Sign-In sudah siap digunakan.**

Jika masih ada masalah, pastikan semua langkah sudah diikuti dengan benar dan tunggu beberapa menit untuk propagasi configuration di Google Cloud Console.
