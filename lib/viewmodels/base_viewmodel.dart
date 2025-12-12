import 'package:flutter/foundation.dart';

/// Base ViewModel class yang akan di-extend oleh semua ViewModel
/// Menyediakan state management dasar dengan ChangeNotifier
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isDisposed = false;
  String? _errorMessage;

  /// Getter untuk loading state
  bool get isLoading => _isLoading;

  /// Getter untuk error message
  String? get errorMessage => _errorMessage;

  /// Setter untuk loading state
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Setter untuk error message
  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Safe notify listeners - hanya notify jika belum disposed
  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  /// Override dispose untuk set flag
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Helper method untuk menjalankan async operation dengan loading state
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
