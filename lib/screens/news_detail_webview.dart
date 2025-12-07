import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:html' as html;

class NewsDetailWebview extends StatefulWidget {
  final String url;
  final String title;

  const NewsDetailWebview({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<NewsDetailWebview> createState() => _NewsDetailWebviewState();
}

class _NewsDetailWebviewState extends State<NewsDetailWebview> {
  late final WebViewController? _controller;
  bool _isLoading = true;
  double _loadingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    
    // Only initialize WebView for non-web platforms
    if (!kIsWeb) {
      _initializeWebView();
    }
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _loadingProgress = 0.0;
            });
          },
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
              _loadingProgress = 1.0;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading page: ${error.description}'),
                backgroundColor: Colors.red,
              ),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            // Allow all navigation within the webview
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: const Color(0xFF0097A7),
        foregroundColor: Colors.white,
        actions: [
          if (!kIsWeb)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _controller?.reload();
              },
              tooltip: 'Refresh',
            ),
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () {
              // Open in external browser
              if (kIsWeb) {
                html.window.open(widget.url, '_blank');
              }
            },
            tooltip: 'Buka di Browser',
          ),
        ],
      ),
      body: kIsWeb ? _buildWebFallback() : _buildWebView(),
    );
  }

  // For web platform - show message to open in browser
  Widget _buildWebFallback() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.open_in_browser,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Buka Berita di Browser',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'WebView tidak tersedia di versi web. Klik tombol di bawah untuk membuka berita di tab baru.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                html.window.open(widget.url, '_blank');
              },
              icon: const Icon(Icons.launch),
              label: const Text('Buka di Tab Baru'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }

  // For mobile/desktop platforms - show WebView
  Widget _buildWebView() {
    return Column(
      children: [
        // Loading progress bar
        if (_isLoading)
          LinearProgressIndicator(
            value: _loadingProgress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF0097A7),
            ),
          ),
        
        // WebView
        Expanded(
          child: WebViewWidget(
            controller: _controller!,
          ),
        ),
      ],
    );
  }
}
