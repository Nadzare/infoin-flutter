# Panduan Testing di HP Android

## Prasyarat
✅ Developer Options sudah aktif
✅ Kabel USB untuk menghubungkan HP ke PC

## Langkah 1: Setup HP Android

### 1.1 Aktifkan USB Debugging
1. Buka **Settings → Developer Options**
2. Aktifkan **USB Debugging**
3. Aktifkan **Install via USB** (jika tersedia)
4. Aktifkan **USB debugging (Security settings)** (jika tersedia)

### 1.2 Sambungkan HP ke PC
1. Colok HP ke komputer dengan kabel USB
2. Pilih mode **File Transfer / MTP** (bukan Charging Only)
3. Di HP akan muncul popup **"Allow USB debugging?"**
   - Tap **Allow**
   - Centang **"Always allow from this computer"**

### 1.3 Verifikasi Koneksi
```powershell
flutter doctor
```

Jika masih belum terdeteksi:
```powershell
# Restart ADB server
flutter doctor --android-licenses
```

## Langkah 2: Install Android SDK Platform Tools (Jika Belum)

Jika `flutter doctor` menunjukkan Android toolchain belum lengkap:

1. Buka **Android Studio**
2. Go to **Settings → Appearance & Behavior → System Settings → Android SDK**
3. Tab **SDK Tools**, install:
   - ✅ Android SDK Platform-Tools
   - ✅ Android SDK Command-line Tools
   - ✅ Google USB Driver (untuk Windows)

4. Restart PowerShell setelah install

## Langkah 3: Setup Google Sign-In untuk Android

### 3.1 Dapatkan SHA-1 Fingerprint
Jalankan di terminal:
```powershell
cd android
./gradlew signingReport
```

Atau dengan keytool:
```powershell
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

Copy **SHA-1** fingerprint yang muncul, contoh:
```
SHA1: A1:B2:C3:D4:E5:F6:G7:H8:I9:J0:K1:L2:M3:N4:O5:P6:Q7:R8:S9:T0
```

### 3.2 Tambahkan SHA-1 ke Google Cloud Console

1. Buka [Google Cloud Console](https://console.cloud.google.com/)
2. Pilih project: **856961816595**
3. Go to **APIs & Services → Credentials**
4. Klik OAuth 2.0 Client ID untuk Android
5. Jika belum ada, klik **+ CREATE CREDENTIALS → OAuth client ID → Android**
6. Isi:
   - **Name**: Infoin Android (Debug)
   - **Package name**: Cek di `android/app/build.gradle.kts` → `applicationId`
   - **SHA-1 certificate fingerprint**: Paste SHA-1 dari langkah 3.1
7. Klik **CREATE**

### 3.3 Cek Package Name
```powershell
# Cek applicationId di build.gradle.kts
Get-Content android/app/build.gradle.kts | Select-String "applicationId"
```

## Langkah 4: Update Server Client ID (Jika Perlu)

Setelah membuat OAuth client ID untuk Android:

1. Copy **Client ID** yang baru dibuat (format: xxx-xxx.apps.googleusercontent.com)
2. Update di `lib/services/auth_service.dart`:

```dart
// Ganti dengan Client ID dari OAuth Android
static const String webClientId = 'YOUR_NEW_CLIENT_ID';
```

⚠️ **ATAU** bisa menggunakan Client ID Web yang sudah ada, tapi **HARUS** tambahkan SHA-1 fingerprint.

## Langkah 5: Jalankan Aplikasi di HP

### 5.1 Cek Device Terdeteksi
```powershell
flutter devices
```

Output yang diharapkan:
```
Found 4 connected devices:
  SM Gxxx (mobile)  • ABC123XYZ • android-arm64  • Android 13 (API 33)
  Windows (desktop) • windows  • windows-x64     • Microsoft Windows
  Chrome (web)      • chrome   • web-javascript  • Google Chrome
  Edge (web)        • edge     • web-javascript  • Microsoft Edge
```

### 5.2 Run di HP
```powershell
# Otomatis pilih device jika hanya ada 1 mobile device
flutter run

# Atau spesifik pilih device
flutter run -d ABC123XYZ
```

### 5.3 Hot Reload
Setelah aplikasi berjalan:
- Tekan **r** untuk reload
- Tekan **R** untuk hot restart
- Tekan **q** untuk quit

## Langkah 6: Testing Google Sign-In

1. Buka aplikasi di HP
2. Tap tombol **"Sign in with Google"**
3. Pilih akun Google
4. Berikan izin yang diminta
5. Seharusnya login berhasil dan redirect ke halaman utama

## Troubleshooting

### Problem: Device tidak terdeteksi
**Solusi:**
- Pastikan USB Debugging aktif
- Ganti kabel USB (gunakan kabel data, bukan charging only)
- Ganti USB port di PC
- Restart HP dan PC
- Install Google USB Driver (Windows)
- Jalankan: `flutter doctor --android-licenses` dan accept semua

### Problem: Error "PlatformException (sign_in_failed)"
**Solusi:**
- SHA-1 fingerprint belum ditambahkan ke Google Cloud Console
- Package name tidak match dengan yang di Google Cloud Console
- Tunggu 5-10 menit setelah update Google Cloud Console

### Problem: Error "ApiException: 10"
**Solusi:**
- Client ID salah atau tidak match
- SHA-1 tidak sesuai
- Package name berbeda

### Problem: Build error di Android
**Solusi:**
```powershell
# Clean build
flutter clean
flutter pub get

# Build ulang
flutter run
```

### Problem: Google Sign-In berhasil tapi profile tidak dibuat
**Solusi:**
- Cek Supabase logs di Dashboard
- Pastikan table `profiles` sudah ada
- Cek RLS (Row Level Security) policy di Supabase

## Tips

1. **Gunakan Release Mode untuk testing performa:**
   ```powershell
   flutter run --release
   ```

2. **Lihat logs:**
   ```powershell
   flutter logs
   ```

3. **Install APK langsung:**
   ```powershell
   flutter build apk
   flutter install
   ```

4. **Debug dengan Chrome DevTools:**
   - Jalankan: `flutter run`
   - Buka URL yang muncul di terminal di Chrome
   - Inspect element, Network, Console, dll tersedia

## Next Steps

Setelah testing di debug mode berhasil:

1. **Buat SHA-1 untuk Release Mode:**
   ```powershell
   keytool -list -v -keystore "path/to/your-release-key.keystore" -alias your-key-alias
   ```

2. **Tambahkan SHA-1 release ke Google Cloud Console**

3. **Build release APK:**
   ```powershell
   flutter build apk --release
   ```

4. **Test di HP tanpa USB:**
   - Kirim APK via email/drive
   - Install di HP
   - Test Google Sign-In

## Referensi
- [Flutter Android Setup](https://docs.flutter.dev/get-started/install/windows#android-setup)
- [Google Sign-In Flutter](https://pub.dev/packages/google_sign_in)
- [Android Debug Bridge (ADB)](https://developer.android.com/tools/adb)
