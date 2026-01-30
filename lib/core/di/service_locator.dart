import 'package:car_owner_app/core/shared/services/api_service.dart';
import 'package:car_owner_app/core/shared/services/storage_service.dart';
import 'package:car_owner_app/core/shared/services/database_service.dart';
import 'package:car_owner_app/core/shared/services/auth_service.dart';

/// Simple service locator for dependency injection
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};
  bool _initialized = false;

  bool get isInitialized => _initialized;

  /// Initialize all services
  Future<void> init() async {
    if (_initialized) return;

    // Register Storage Service first (needed by others)
    final storageService = StorageService();
    await storageService.init();
    register<StorageService>(storageService);

    // Register Database Service
    final databaseService = DatabaseService();
    await databaseService.init();
    register<DatabaseService>(databaseService);

    // Register API Service (depends on storage)
    final apiService = ApiService();
    apiService.initialize(storageService: storageService);
    register<ApiService>(apiService);

    // Register Auth Service (depends on API and storage)
    final authService = AuthService();
    await authService.init();
    register<AuthService>(authService);

    _initialized = true;
  }

  /// Register a service instance
  void register<T>(T service) {
    _services[T] = service;
  }

  /// Get a registered service
  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('Service $T not registered. Call init() first.');
    }
    return service as T;
  }

  /// Check if a service is registered
  bool isRegistered<T>() {
    return _services.containsKey(T);
  }

  /// Reset all services (useful for testing)
  void reset() {
    _services.clear();
    _initialized = false;
  }

  /// Dispose all services
  Future<void> dispose() async {
    if (isRegistered<DatabaseService>()) {
      await get<DatabaseService>().close();
    }
    reset();
  }
}

/// Global accessor for service locator
final sl = ServiceLocator();
