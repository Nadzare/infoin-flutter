import '../models/news_model.dart';
import '../models/chat_model.dart';
import '../models/category_model.dart';
import '../models/community_news_model.dart';
import '../models/news_source_model.dart';

// Nama user saat ini (untuk filter postingan)
const String currentUserName = 'John Doe';
const String currentUserAvatar = '👨‍💼';

// Dummy News Articles
final List<NewsArticle> dummyNews = [
  NewsArticle(
    id: '1',
    title: 'Teknologi AI Terbaru Mengubah Cara Kita Bekerja',
    description: 'Perkembangan kecerdasan buatan terus menghadirkan inovasi baru yang memudahkan pekerjaan manusia di berbagai sektor.',
    imageUrl: 'https://placehold.co/600x400/1976D2/FFFFFF/png?text=AI+Technology',
    source: 'TechNews Indonesia',
    publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
    category: 'Teknologi',
    content: 'Konten lengkap berita tentang perkembangan AI...',
    url: 'https://example.com/ai-technology',
  ),
  NewsArticle(
    id: '2',
    title: 'Tips Hidup Sehat di Era Modern',
    description: 'Para ahli kesehatan membagikan tips praktis untuk menjaga kesehatan di tengah kesibukan.',
    imageUrl: 'https://placehold.co/600x400/4CAF50/FFFFFF/png?text=Health+Tips',
    source: 'Sehat Indonesia',
    publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
    category: 'Kesehatan',
    content: 'Konten lengkap tentang tips hidup sehat...',
    url: 'https://example.com/health-tips',
  ),
  NewsArticle(
    id: '3',
    title: 'Timnas Indonesia Raih Kemenangan Gemilang',
    description: 'Pertandingan seru berakhir dengan kemenangan telak untuk tim tanah air.',
    imageUrl: 'https://placehold.co/600x400/F44336/FFFFFF/png?text=Sports+Victory',
    source: 'Olahraga News',
    publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
    category: 'Olahraga',
    content: 'Konten lengkap tentang pertandingan...',
    url: 'https://example.com/sports-victory',
  ),
  NewsArticle(
    id: '4',
    title: 'Ekonomi Digital Indonesia Terus Berkembang',
    description: 'Pertumbuhan ekonomi digital mencapai angka fantastis di kuartal ini.',
    imageUrl: 'https://placehold.co/600x400/FF9800/FFFFFF/png?text=Digital+Economy',
    source: 'Ekonomi Today',
    publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
    category: 'Ekonomi',
    content: 'Konten lengkap tentang ekonomi digital...',
    url: 'https://example.com/digital-economy',
  ),
  NewsArticle(
    id: '5',
    title: 'Destinasi Wisata Tersembunyi di Nusantara',
    description: 'Jelajahi keindahan alam Indonesia yang masih tersembunyi dan eksotis.',
    imageUrl: 'https://placehold.co/600x400/009688/FFFFFF/png?text=Travel+Paradise',
    source: 'Travel Indonesia',
    publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    category: 'Travel',
    content: 'Konten lengkap tentang destinasi wisata...',
    url: 'https://example.com/travel-paradise',
  ),
  NewsArticle(
    id: '6',
    title: 'Inovasi Pendidikan dengan Metode Pembelajaran Baru',
    description: 'Metode pembelajaran inovatif meningkatkan kualitas pendidikan di Indonesia.',
    imageUrl: 'https://placehold.co/600x400/673AB7/FFFFFF/png?text=Education+Innovation',
    source: 'Edukasi News',
    publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    category: 'Pendidikan',
    content: 'Konten lengkap tentang inovasi pendidikan...',
    url: 'https://example.com/education-innovation',
  ),
];

// Dummy Chat Messages
final List<ChatMessage> dummyChatMessages = [
  ChatMessage(
    id: '1',
    message: 'Halo! Saya adalah asisten AI Infoin. Ada yang bisa saya bantu?',
    isUser: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
  ChatMessage(
    id: '2',
    message: 'Halo! Bisakah kamu merangkum berita teknologi hari ini?',
    isUser: true,
    timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
  ),
  ChatMessage(
    id: '3',
    message: 'Tentu! Berita teknologi hari ini berfokus pada perkembangan AI yang semakin pesat. Teknologi AI kini telah mengubah cara kita bekerja dengan menghadirkan otomasi cerdas dan analisis data yang lebih akurat. Apakah ada topik spesifik yang ingin kamu ketahui lebih lanjut?',
    isUser: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
  ),
];

// Dummy Categories
final List<NewsCategory> dummyCategories = [
  NewsCategory(id: '1', name: 'Teknologi', icon: '💻'),
  NewsCategory(id: '2', name: 'Kesehatan', icon: '🏥'),
  NewsCategory(id: '3', name: 'Olahraga', icon: '⚽'),
  NewsCategory(id: '4', name: 'Ekonomi', icon: '💰'),
  NewsCategory(id: '5', name: 'Travel', icon: '✈️'),
  NewsCategory(id: '6', name: 'Pendidikan', icon: '📚'),
  NewsCategory(id: '7', name: 'Hiburan', icon: '🎬'),
  NewsCategory(id: '8', name: 'Politik', icon: '🏛️'),
];

// Dummy Countries
final List<Map<String, String>> dummyCountries = [
  {'code': 'ID', 'name': 'Indonesia', 'flag': '🇮🇩'},
  {'code': 'US', 'name': 'United States', 'flag': '🇺🇸'},
  {'code': 'GB', 'name': 'United Kingdom', 'flag': '🇬🇧'},
  {'code': 'AU', 'name': 'Australia', 'flag': '🇦🇺'},
  {'code': 'JP', 'name': 'Japan', 'flag': '🇯🇵'},
  {'code': 'SG', 'name': 'Singapore', 'flag': '🇸🇬'},
];

// Dummy Topics
final List<String> dummyTopics = [
  'Teknologi',
  'Kesehatan',
  'Olahraga',
  'Ekonomi',
  'Travel',
  'Pendidikan',
  'Hiburan',
  'Politik',
  'Sains',
  'Otomotif',
];

// Dummy News Sources
final List<Map<String, String>> dummyNewsSources = [
  {'id': '1', 'name': 'TechNews Indonesia', 'logo': '📱'},
  {'id': '2', 'name': 'Sehat Indonesia', 'logo': '💊'},
  {'id': '3', 'name': 'Olahraga News', 'logo': '🏆'},
  {'id': '4', 'name': 'Ekonomi Today', 'logo': '📈'},
  {'id': '5', 'name': 'Travel Indonesia', 'logo': '🌏'},
  {'id': '6', 'name': 'Edukasi News', 'logo': '🎓'},
  {'id': '7', 'name': 'Berita Harian', 'logo': '📰'},
  {'id': '8', 'name': 'Info Terkini', 'logo': '📡'},
];

// Dummy Community News (User Generated Content)
final List<CommunityNews> dummyCommunityNews = [
  CommunityNews(
    id: 'c1',
    userId: 'dummy1',
    title: 'Tips Merawat Tanaman Hias di Rumah',
    content: 'Halo teman-teman! Saya ingin berbagi tips merawat tanaman hias yang sudah saya praktikkan selama 2 tahun. Pertama, pastikan tanaman mendapat cahaya yang cukup...',
    imageUrl: 'https://placehold.co/600x400/4CAF50/FFFFFF/png?text=Plant+Care',
    authorName: 'Siti Nurhaliza',
    authorAvatar: '👩',
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    category: 'Lifestyle',
    likesCount: 24,
    commentsCount: 8,
  ),
  CommunityNews(
    id: 'c2',
    userId: 'dummy2',
    title: 'Review Kuliner: Warung Makan Tradisional di Yogyakarta',
    content: 'Kemarin saya mencoba warung makan tradisional yang sangat recommended di daerah Kotagede. Makanannya enak dan harganya terjangkau!',
    imageUrl: 'https://placehold.co/600x400/FF9800/FFFFFF/png?text=Indonesian+Food',
    authorName: 'John Doe',
    authorAvatar: '👨',
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    category: 'Kuliner',
    likesCount: 45,
    commentsCount: 12,
  ),
  CommunityNews(
    id: 'c3',
    userId: 'dummy2',
    title: 'Pengalaman Pertama Mendaki Gunung Semeru',
    content: 'Akhirnya impian saya mendaki Gunung Semeru tercapai! Perjalanan yang melelahkan tapi pemandangannya luar biasa indah. Berikut tips dari saya...',
    imageUrl: 'https://placehold.co/600x400/2196F3/FFFFFF/png?text=Mountain+Hiking',
    authorName: 'John Doe',
    authorAvatar: '👨',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    category: 'Travel',
    likesCount: 67,
    commentsCount: 15,
  ),
  CommunityNews(
    id: 'c4',
    userId: 'dummy3',
    title: 'Cara Membuat Website Sederhana untuk Pemula',
    content: 'Tutorial lengkap membuat website sederhana menggunakan HTML, CSS, dan JavaScript untuk pemula. Sangat cocok bagi yang baru belajar coding!',
    imageUrl: 'https://placehold.co/600x400/9C27B0/FFFFFF/png?text=Web+Development',
    authorName: 'Rina Melati',
    authorAvatar: '👩',
    createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    category: 'Teknologi',
    likesCount: 89,
    commentsCount: 23,
  ),
  CommunityNews(
    id: 'c5',
    userId: 'dummy2',
    title: 'Resep Brownies Kukus Coklat yang Lembut',
    content: 'Mau bikin brownies kukus yang lembut dan enak? Ini resep favorit keluarga saya yang sudah teruji berkali-kali. Bahan-bahannya mudah didapat!',
    imageUrl: 'https://placehold.co/600x400/795548/FFFFFF/png?text=Brownies+Recipe',
    authorName: 'John Doe',
    authorAvatar: '👨',
    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    category: 'Kuliner',
    likesCount: 52,
    commentsCount: 18,
  ),
];

// Dummy Recent News (Recently Viewed by User)
final List<NewsArticle> recentlyViewedNews = [
  NewsArticle(
    id: 'r1',
    title: 'Teknologi AI Terbaru Mengubah Cara Kita Bekerja',
    description: 'Perkembangan kecerdasan buatan terus menghadirkan inovasi baru.',
    imageUrl: 'https://placehold.co/600x400/1976D2/FFFFFF/png?text=AI+Technology',
    source: 'TechNews Indonesia',
    publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
    category: 'Teknologi',
    content: 'Konten lengkap berita tentang perkembangan AI...',
    url: 'https://example.com/ai-technology',
  ),
  NewsArticle(
    id: 'r2',
    title: 'Ekonomi Digital Indonesia Terus Berkembang',
    description: 'Pertumbuhan ekonomi digital mencapai angka fantastis.',
    imageUrl: 'https://placehold.co/600x400/FF9800/FFFFFF/png?text=Digital+Economy',
    source: 'Ekonomi Today',
    publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
    category: 'Ekonomi',
    content: 'Konten lengkap tentang ekonomi digital...',
    url: 'https://example.com/digital-economy',
  ),
  NewsArticle(
    id: 'r3',
    title: 'Destinasi Wisata Tersembunyi di Nusantara',
    description: 'Jelajahi keindahan alam Indonesia yang masih tersembunyi.',
    imageUrl: 'https://placehold.co/600x400/009688/FFFFFF/png?text=Travel+Paradise',
    source: 'Travel Indonesia',
    publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    category: 'Travel',
    content: 'Konten lengkap tentang destinasi wisata...',
    url: 'https://example.com/travel-paradise',
  ),
  NewsArticle(
    id: 'r4',
    title: 'Tips Hidup Sehat di Era Modern',
    description: 'Para ahli kesehatan membagikan tips praktis.',
    imageUrl: 'https://placehold.co/600x400/4CAF50/FFFFFF/png?text=Health+Tips',
    source: 'Sehat Indonesia',
    publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
    category: 'Kesehatan',
    content: 'Konten lengkap tentang tips hidup sehat...',
    url: 'https://example.com/health-tips',
  ),
];

// Available News Sources (Global + Local)
final List<NewsSource> availableSources = [
  // Global Sources
  NewsSource(
    id: 's1',
    name: 'CNN',
    logoUrl: 'lib/images/news/logo_cnn.png',
    type: 'global',
  ),
  NewsSource(
    id: 's2',
    name: 'BBC News',
    logoUrl: 'lib/images/news/logo_bbc_news.png',
    type: 'global',
  ),
  NewsSource(
    id: 's3',
    name: 'CNBC',
    logoUrl: 'lib/images/news/logo_cnbc.png',
    type: 'global',
  ),
  NewsSource(
    id: 's4',
    name: 'TIME',
    logoUrl: 'lib/images/news/logo_time.png',
    type: 'global',
  ),
  NewsSource(
    id: 's5',
    name: 'VICE',
    logoUrl: 'lib/images/news/logo_vice.png',
    type: 'global',
  ),
  NewsSource(
    id: 's6',
    name: 'Vox',
    logoUrl: 'lib/images/news/logo_vox.png',
    type: 'global',
  ),
  NewsSource(
    id: 's7',
    name: 'BuzzFeed',
    logoUrl: 'lib/images/news/logo_buzzfeed.png',
    type: 'global',
  ),
  NewsSource(
    id: 's8',
    name: 'CNET',
    logoUrl: 'lib/images/news/logo_cnet.png',
    type: 'global',
  ),
  NewsSource(
    id: 's9',
    name: 'Daily Mail',
    logoUrl: 'lib/images/news/logo_daily_mail.png',
    type: 'global',
  ),
  NewsSource(
    id: 's10',
    name: 'USA Today',
    logoUrl: 'lib/images/news/logo_usa_today.png',
    type: 'global',
  ),
  NewsSource(
    id: 's11',
    name: 'MSN',
    logoUrl: 'lib/images/news/logo_msn.png',
    type: 'global',
  ),
  NewsSource(
    id: 's12',
    name: 'SCMP',
    logoUrl: 'lib/images/news/logo_scmp.png',
    type: 'global',
  ),
  // Local Sources (Indonesia)
  NewsSource(
    id: 's13',
    name: 'Detikcom',
    logoUrl: 'lib/images/news/ic_detikcom.png',
    type: 'local',
  ),
  NewsSource(
    id: 's14',
    name: 'Liputan6',
    logoUrl: 'lib/images/news/ic_liputan6.png',
    type: 'local',
  ),
  NewsSource(
    id: 's15',
    name: 'Tribunnews',
    logoUrl: 'lib/images/news/ic_tribunews.jpeg',
    type: 'local',
  ),
  NewsSource(
    id: 's16',
    name: 'Sindonews',
    logoUrl: 'lib/images/news/ic_sindonews.png',
    type: 'local',
  ),
  NewsSource(
    id: 's17',
    name: 'Republika',
    logoUrl: 'lib/images/news/ic_rm_id.jpg',
    type: 'local',
  ),
];
