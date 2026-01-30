import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:car_owner_app/core/constants/app_constants.dart';

/// Service for local SQLite database operations
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;
  bool _initialized = false;

  bool get isInitialized => _initialized;

  /// Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    // Cache table for discovery items
    await db.execute('''
      CREATE TABLE discovery_cache (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        content TEXT,
        image TEXT,
        images TEXT,
        tag TEXT,
        tag_color TEXT,
        user_data TEXT,
        likes INTEGER DEFAULT 0,
        comments INTEGER DEFAULT 0,
        shares INTEGER DEFAULT 0,
        is_video INTEGER DEFAULT 0,
        created_at TEXT,
        cached_at TEXT NOT NULL
      )
    ''');

    // Cache table for store products
    await db.execute('''
      CREATE TABLE products_cache (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        original_price REAL,
        image TEXT,
        category_id INTEGER,
        tags TEXT,
        points INTEGER,
        stock_quantity INTEGER DEFAULT 0,
        sales_count INTEGER DEFAULT 0,
        is_active INTEGER DEFAULT 1,
        is_featured INTEGER DEFAULT 0,
        created_at TEXT,
        cached_at TEXT NOT NULL
      )
    ''');

    // Cache table for car models
    await db.execute('''
      CREATE TABLE cars_cache (
        id TEXT PRIMARY KEY,
        model_key TEXT,
        name TEXT NOT NULL,
        full_name TEXT,
        subtitle TEXT,
        price REAL NOT NULL,
        price_unit TEXT,
        background_image TEXT,
        promo_price TEXT,
        highlight_image TEXT,
        highlight_text TEXT,
        vr_image TEXT,
        store_data TEXT,
        is_preview INTEGER DEFAULT 0,
        release_date TEXT,
        versions TEXT,
        preview_features TEXT,
        created_at TEXT,
        cached_at TEXT NOT NULL
      )
    ''');

    // User data cache
    await db.execute('''
      CREATE TABLE user_cache (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');

    _initialized = true;
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations here
    if (oldVersion < 2) {
      // Example migration
    }
  }

  /// Initialize the service
  Future<void> init() async {
    if (_initialized) return;
    await database;
    _initialized = true;
  }

  /// Clear all cached data
  Future<void> clearAllCache() async {
    final db = await database;
    await db.delete('discovery_cache');
    await db.delete('products_cache');
    await db.delete('cars_cache');
    await db.delete('user_cache');
  }

  /// Clear cache older than specified duration
  Future<void> clearOldCache(Duration maxAge) async {
    final db = await database;
    final cutoff = DateTime.now().subtract(maxAge).toIso8601String();
    
    await db.delete(
      'discovery_cache',
      where: 'cached_at < ?',
      whereArgs: [cutoff],
    );
    await db.delete(
      'products_cache',
      where: 'cached_at < ?',
      whereArgs: [cutoff],
    );
    await db.delete(
      'cars_cache',
      where: 'cached_at < ?',
      whereArgs: [cutoff],
    );
  }

  // Discovery cache operations

  /// Cache discovery items
  Future<void> cacheDiscoveryItems(List<Map<String, dynamic>> items) async {
    final db = await database;
    final batch = db.batch();
    final now = DateTime.now().toIso8601String();

    for (final item in items) {
      batch.insert(
        'discovery_cache',
        {
          'id': item['id'],
          'type': item['type'],
          'title': item['title'],
          'content': item['content'],
          'image': item['image'],
          'images': item['images']?.toString(),
          'tag': item['tag'],
          'tag_color': item['tagColor'],
          'user_data': item['user']?.toString(),
          'likes': item['likes'] ?? 0,
          'comments': item['comments'] ?? 0,
          'shares': item['shares'] ?? 0,
          'is_video': (item['isVideo'] ?? false) ? 1 : 0,
          'created_at': item['createdAt'],
          'cached_at': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  /// Get cached discovery items
  Future<List<Map<String, dynamic>>> getCachedDiscoveryItems() async {
    final db = await database;
    return await db.query('discovery_cache', orderBy: 'cached_at DESC');
  }

  // Products cache operations

  /// Cache products
  Future<void> cacheProducts(List<Map<String, dynamic>> products) async {
    final db = await database;
    final batch = db.batch();
    final now = DateTime.now().toIso8601String();

    for (final product in products) {
      batch.insert(
        'products_cache',
        {
          'id': product['id'],
          'title': product['title'],
          'description': product['description'],
          'price': product['price'],
          'original_price': product['originalPrice'],
          'image': product['image'],
          'category_id': product['categoryId'],
          'tags': product['tags']?.toString(),
          'points': product['points'],
          'stock_quantity': product['stockQuantity'] ?? 0,
          'sales_count': product['salesCount'] ?? 0,
          'is_active': (product['isActive'] ?? true) ? 1 : 0,
          'is_featured': (product['isFeatured'] ?? false) ? 1 : 0,
          'created_at': product['createdAt'],
          'cached_at': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  /// Get cached products
  Future<List<Map<String, dynamic>>> getCachedProducts() async {
    final db = await database;
    return await db.query('products_cache', orderBy: 'cached_at DESC');
  }

  // Cars cache operations

  /// Cache car models
  Future<void> cacheCars(List<Map<String, dynamic>> cars) async {
    final db = await database;
    final batch = db.batch();
    final now = DateTime.now().toIso8601String();

    for (final car in cars) {
      batch.insert(
        'cars_cache',
        {
          'id': car['id'],
          'model_key': car['modelKey'],
          'name': car['name'],
          'full_name': car['fullName'],
          'subtitle': car['subtitle'],
          'price': car['price'],
          'price_unit': car['priceUnit'],
          'background_image': car['backgroundImage'],
          'promo_price': car['promoPrice'],
          'highlight_image': car['highlightImage'],
          'highlight_text': car['highlightText'],
          'vr_image': car['vrImage'],
          'store_data': car['store']?.toString(),
          'is_preview': (car['isPreview'] ?? false) ? 1 : 0,
          'release_date': car['releaseDate'],
          'versions': car['versions']?.toString(),
          'preview_features': car['previewFeatures']?.toString(),
          'created_at': car['createdAt'],
          'cached_at': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  /// Get cached car models
  Future<List<Map<String, dynamic>>> getCachedCars() async {
    final db = await database;
    return await db.query('cars_cache', orderBy: 'cached_at DESC');
  }

  // User cache operations

  /// Save user data to cache
  Future<void> saveUserData(String key, String value) async {
    final db = await database;
    await db.insert(
      'user_cache',
      {
        'key': key,
        'value': value,
        'cached_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get user data from cache
  Future<String?> getUserData(String key) async {
    final db = await database;
    final result = await db.query(
      'user_cache',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) return null;
    return result.first['value'] as String?;
  }

  /// Delete user data from cache
  Future<void> deleteUserData(String key) async {
    final db = await database;
    await db.delete(
      'user_cache',
      where: 'key = ?',
      whereArgs: [key],
    );
  }

  /// Close database connection
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      _initialized = false;
    }
  }
}
