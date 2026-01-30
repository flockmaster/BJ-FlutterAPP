import 'package:car_owner_app/core/base/base_state.dart';
import 'package:car_owner_app/core/di/service_locator.dart';
import 'api_service.dart';
import 'storage_service.dart';

/// Authentication response model
class AuthResponse {
  final String token;
  final String? refreshToken;
  final Map<String, dynamic> user;
  final DateTime? expiresAt;

  AuthResponse({
    required this.token,
    this.refreshToken,
    required this.user,
    this.expiresAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? json['accessToken'] ?? '',
      refreshToken: json['refreshToken'],
      user: json['user'] ?? {},
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'])
          : null,
    );
  }
}

/// Service for authentication operations
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = sl.get<ApiService>();
  final StorageService _storageService = sl.get<StorageService>();

  bool _isAuthenticated = false;
  Map<String, dynamic>? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get currentUser => _currentUser;

  /// Initialize auth state from storage
  Future<void> init() async {
    final token = _storageService.getUserToken();
    final userData = _storageService.getUserData();
    
    if (token != null && token.isNotEmpty) {
      _isAuthenticated = true;
      _currentUser = userData;
    }
  }

  /// Login with username/email and password
  Future<Result<AuthResponse>> login(String username, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        Map<String, dynamic> authData;
        
        if (data is Map && data['data'] != null) {
          authData = data['data'] as Map<String, dynamic>;
        } else if (data is Map) {
          authData = data as Map<String, dynamic>;
        } else {
          return Result.failure('Invalid response format');
        }

        final authResponse = AuthResponse.fromJson(authData);
        
        // Save auth data
        await _storageService.saveUserToken(authResponse.token);
        await _storageService.saveUserData(authResponse.user);
        
        _isAuthenticated = true;
        _currentUser = authResponse.user;
        
        return Result.success(authResponse);
      }

      return Result.failure('登录失败');
    } on ApiException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('登录失败: ${e.toString()}');
    }
  }

  /// Register new user
  Future<Result<AuthResponse>> register({
    required String username,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
          if (phone != null) 'phone': phone,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        Map<String, dynamic> authData;
        
        if (data is Map && data['data'] != null) {
          authData = data['data'] as Map<String, dynamic>;
        } else if (data is Map) {
          authData = data as Map<String, dynamic>;
        } else {
          return Result.failure('Invalid response format');
        }

        final authResponse = AuthResponse.fromJson(authData);
        
        // Save auth data
        await _storageService.saveUserToken(authResponse.token);
        await _storageService.saveUserData(authResponse.user);
        
        _isAuthenticated = true;
        _currentUser = authResponse.user;
        
        return Result.success(authResponse);
      }

      return Result.failure('注册失败');
    } on ApiException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('注册失败: ${e.toString()}');
    }
  }

  /// Refresh auth token
  Future<Result<String>> refreshToken() async {
    try {
      final response = await _apiService.post('/auth/refresh');

      if (response.statusCode == 200) {
        final data = response.data;
        String? newToken;
        
        if (data is Map) {
          newToken = data['token'] ?? data['data']?['token'];
        }
        
        if (newToken != null) {
          await _storageService.saveUserToken(newToken);
          return Result.success(newToken);
        }
      }

      return Result.failure('刷新令牌失败');
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await logout();
      }
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('刷新令牌失败: ${e.toString()}');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // Try to notify server (optional)
      await _apiService.post('/auth/logout');
    } catch (e) {
      // Ignore errors during logout
    }
    
    // Clear local data
    await _storageService.clearUserSession();
    _isAuthenticated = false;
    _currentUser = null;
  }

  /// Check if token is valid
  Future<bool> validateToken() async {
    final token = _storageService.getUserToken();
    if (token == null || token.isEmpty) {
      _isAuthenticated = false;
      return false;
    }

    try {
      final response = await _apiService.get('/auth/validate');
      _isAuthenticated = response.statusCode == 200;
      return _isAuthenticated;
    } catch (e) {
      _isAuthenticated = false;
      return false;
    }
  }

  /// Update current user data
  void updateCurrentUser(Map<String, dynamic> userData) {
    _currentUser = userData;
    _storageService.saveUserData(userData);
  }
}
