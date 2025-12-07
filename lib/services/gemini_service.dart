import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:collection';

/// Rate limiter untuk handle pembatasan request API
class RateLimiter {
  final int maxRequests;
  final Duration timeWindow;
  final Queue<DateTime> _requestTimes = Queue();

  RateLimiter({
    required this.maxRequests,
    required this.timeWindow,
  });

  /// Check apakah request diizinkan
  bool canMakeRequest() {
    final now = DateTime.now();
    
    // Hapus request yang sudah di luar time window
    while (_requestTimes.isNotEmpty && 
           now.difference(_requestTimes.first).inMilliseconds > timeWindow.inMilliseconds) {
      _requestTimes.removeFirst();
    }
    
    // Jika belum mencapai limit, izinkan request
    if (_requestTimes.length < maxRequests) {
      _requestTimes.addLast(now);
      return true;
    }
    
    return false;
  }

  /// Hitung sisa waktu sebelum dapat request baru (dalam detik)
  int getWaitTimeSeconds() {
    if (_requestTimes.isEmpty) return 0;
    
    final oldestRequest = _requestTimes.first;
    final now = DateTime.now();
    final elapsed = now.difference(oldestRequest).inMilliseconds;
    final waitTime = (timeWindow.inMilliseconds - elapsed) ~/ 1000;
    
    return waitTime > 0 ? waitTime : 0;
  }
}

class GeminiService {
  // Get your free API key from: https://aistudio.google.com/app/apikey
  // Documentation: https://ai.google.dev/gemini-api/docs
  static const String _apiKey = 'AIzaSyAhOnRRn7KmsILJDMsQiVvNWuxpQ6pj7xQ';
  
  // Rate limiter: 15 request per menit (sesuai dengan free tier Gemini)
  static final RateLimiter _rateLimiter = RateLimiter(
    maxRequests: 15,
    timeWindow: const Duration(minutes: 1),
  );
  
  // Cache untuk menghindari request duplicate
  static final Map<String, Map<String, dynamic>> _cache = {};
  static const int cacheExpiryMinutes = 30;

  /// Generate cache key dari parameter
  static String _generateCacheKey(String message, List<Map<String, String>>? history) {
    final historyKey = history != null ? history.map((h) => h['content']).join('|') : 'no-history';
    return '$message|$historyKey';
  }

  /// Check apakah data ada di cache dan masih valid
  static bool _isCacheValid(String cacheKey) {
    if (!_cache.containsKey(cacheKey)) return false;
    
    final cacheData = _cache[cacheKey];
    if (cacheData == null) return false;
    
    final timestamp = cacheData['timestamp'] as DateTime;
    final now = DateTime.now();
    
    return now.difference(timestamp).inMinutes < cacheExpiryMinutes;
  }

  /// Send message to Gemini and get response with rate limiting and caching
  static Future<Map<String, dynamic>> sendMessage(
    String message, {
    bool useCache = true,
    List<Map<String, String>>? history,
  }) async {
    final cacheKey = _generateCacheKey(message, history);
    
    // Cek cache terlebih dahulu
    if (useCache && _isCacheValid(cacheKey)) {
      return {
        'success': true,
        'message': _cache[cacheKey]!['data'],
        'fromCache': true,
      };
    }

    // Cek rate limit
    if (!_rateLimiter.canMakeRequest()) {
      final waitTime = _rateLimiter.getWaitTimeSeconds();
      return {
        'success': false,
        'error': 'Terlalu banyak permintaan. Silakan tunggu ${waitTime} detik.',
        'waitTime': waitTime,
        'rateLimited': true,
      };
    }

    try {
      final response = await _callGeminiAPI(message, history);
      
      // Simpan ke cache jika sukses
      if (response['success'] && useCache) {
        _cache[cacheKey] = {
          'data': response['message'],
          'timestamp': DateTime.now(),
        };
      }
      
      return response;
    } catch (e) {
      print('Error sending message to Gemini: $e');
      return {
        'success': false,
        'error': 'Terjadi kesalahan: $e',
      };
    }
  }

  /// Send message via REST API using latest Gemini 2.5 Flash model
  /// Reference: https://ai.google.dev/api/generate-content
  static Future<Map<String, dynamic>> _callGeminiAPI(
    String message,
    List<Map<String, String>>? history,
  ) async {
    final systemInstruction = '''Kamu adalah AI Assistant untuk aplikasi berita Infoin.
Tugasmu adalah membantu user mencari informasi berita, menjawab pertanyaan seputar berita terkini, 
memberikan ringkasan berita, dan memberikan rekomendasi berita yang relevan.
Jawab dengan bahasa Indonesia yang ramah dan profesional.
Jika user bertanya tentang berita spesifik yang tidak kamu ketahui, 
sarankan mereka untuk mencari di tab Explore atau Home.''';

    // Use gemini-2.5-flash (latest model) without API key in URL
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent',
    );

    // Build contents array with history if available
    final List<Map<String, dynamic>> contents = [];
    
    // Add history messages if available
    if (history != null && history.isNotEmpty) {
      for (var msg in history) {
        contents.add({
          'role': msg['role'] == 'user' ? 'user' : 'model',
          'parts': [{'text': msg['content']}]
        });
      }
    }
    
    // Add current message
    contents.add({
      'role': 'user',
      'parts': [{'text': message}]
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': _apiKey, // Use x-goog-api-key header (recommended)
        },
        body: jsonEncode({
          'contents': contents,
          'systemInstruction': {
            'parts': [{'text': systemInstruction}]
          },
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          }
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Parse response according to API documentation
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          final content = candidate['content'];
          final parts = content['parts'];
          
          if (parts != null && parts.isNotEmpty) {
            final text = parts[0]['text'] as String;
            final finishReason = candidate['finishReason'] ?? 'UNKNOWN';
            
            return {
              'success': true,
              'message': text,
              'finishReason': finishReason,
              'modelVersion': data['modelVersion'],
            };
          }
        }
        
        return {
          'success': false,
          'error': 'Response tidak mengandung konten yang valid',
        };
      } else if (response.statusCode == 429) {
        return {
          'success': false,
          'error': 'Batas permintaan API tercapai. Silakan coba lagi nanti.',
          'rateLimited': true,
        };
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'Unknown error';
        print('Gemini API Error: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'error': 'API Error: $errorMessage',
        };
      }
    } on TimeoutException {
      return {
        'success': false,
        'error': 'Request timeout. Silakan coba lagi.',
      };
    } catch (e) {
      print('Gemini Request Error: $e');
      return {
        'success': false,
        'error': 'Error koneksi: $e',
      };
    }
  }

  /// Send message with chat history for context-aware conversation
  static Future<Map<String, dynamic>> sendMessageWithHistory(
    String message,
    List<Map<String, String>> history,
  ) async {
    return await sendMessage(message, history: history, useCache: false);
  }

  /// Get news summary from Gemini
  static Future<Map<String, dynamic>> getNewsSummary(String newsTitle, String newsContent) async {
    final prompt = '''
Buatkan ringkasan singkat dari berita berikut:

Judul: $newsTitle

Konten: $newsContent

Berikan ringkasan dalam 2-3 kalimat yang mencakup poin-poin penting.
''';

    return await sendMessage(prompt);
  }

  /// Ask question about news
  static Future<Map<String, dynamic>> askAboutNews(String question, String newsContext) async {
    final prompt = '''
Berdasarkan konteks berita berikut:
$newsContext

Pertanyaan user: $question

Jawab pertanyaan dengan informatif dan jelas.
''';

    return await sendMessage(prompt);
  }

  /// Get rate limit status
  static Map<String, dynamic> getRateLimitStatus() {
    return {
      'canMakeRequest': _rateLimiter.canMakeRequest(),
      'waitTimeSeconds': _rateLimiter.getWaitTimeSeconds(),
      'requestsRemaining': _rateLimiter.maxRequests - _rateLimiter._requestTimes.length,
    };
  }

  /// Clear cache (opsional)
  static void clearCache() {
    _cache.clear();
  }
}
