import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

/// [LocalAssetServer] - 本地资源 HTTP 服务器
/// 
/// 核心用途：
/// 在 WebView 中直接通过 `file://` 协议加载本地 GLB/GLTF 模型文件常受安全限制。
/// 该类通过启动一个微型的本地 HTTP 服务 (默认 8080 端口)，让 WebView 可以通过 `http://127.0.0.1:8080/` 访问项目 Assets 资源。
class LocalAssetServer {
  // 单例服务器实例
  static HttpServer? _server;
  static const int _port = 8080;
  static const String _host = '127.0.0.1';
  
  /// 判断服务器是否正在运行
  static bool get isRunning => _server != null;
  
  /// 获取本地服务器的基础 URL
  static String get baseUrl => 'http://$_host:$_port';
  
  /// 启动本地服务器
  /// 自动配置 CORS 中间件以允许跨域访问。
  static Future<String> start() async {
    if (_server != null) {
      print('LocalAssetServer: 服务已在 $baseUrl 运行');
      return baseUrl;
    }

    try {
      // 组装 shelf 管道处理器
      final handler = const shelf.Pipeline()
          .addMiddleware(_corsMiddleware())
          .addMiddleware(shelf.logRequests()) // 记录请求日志便于调试
          .addHandler(_handleRequest);

      // 绑定 IP 与端口并启动
      _server = await shelf_io.serve(
        handler,
        _host,
        _port,
      );

      print('LocalAssetServer: 服务启动成功 $baseUrl');
      return baseUrl;
    } catch (e) {
      print('LocalAssetServer: 启动失败: $e');
      rethrow;
    }
  }

  /// 停止并销毁服务器，释放资源
  static Future<void> stop() async {
    if (_server != null) {
      await _server!.close(force: true);
      _server = null;
      print('LocalAssetServer: 服务已停止');
    }
  }

  /// CORS 中间件：允许来自 WebView 的跨域资源共享
  static shelf.Middleware _corsMiddleware() {
    return shelf.createMiddleware(
      responseHandler: (shelf.Response response) {
        return response.change(headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
          'Access-Control-Max-Age': '86400',
        });
      },
    );
  }

  /// 核心请求处理器：将 URL 路径映射为 assets 资源并返回
  static Future<shelf.Response> _handleRequest(shelf.Request request) async {
    // 处理 OPTIONS 预检请求实现跨域
    if (request.method == 'OPTIONS') {
      return shelf.Response.ok('', headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
      });
    }

    if (request.method != 'GET') {
      return shelf.Response.notFound('仅支持 GET 请求');
    }

    try {
      final requestPath = request.url.path;
      print('LocalAssetServer: 收到请求 -> $requestPath');

      // 资源路径重映射：统一映射到 assets/ 目录下
      String assetPath;
      if (requestPath.startsWith('models/')) {
        assetPath = 'assets/$requestPath';
      } else if (requestPath.isEmpty || requestPath == '/') {
        return shelf.Response.ok('本地资源服务器正在运行...');
      } else {
        assetPath = 'assets/models/$requestPath';
      }

      // 从 Flutter APK/IPA 资源包中读取二进制数据
      final ByteData data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();

      // 根据文件后缀决定 MIME 类型，确保 WebView 正确解析（尤其是 .glb 模型）
      final mimeType = _getMimeType(assetPath);

      print('LocalAssetServer: 响应资源 $assetPath (${bytes.length} 字节, $mimeType)');

      return shelf.Response.ok(
        bytes,
        headers: {
          'Content-Type': mimeType,
          'Content-Length': '${bytes.length}',
          'Cache-Control': 'public, max-age=3600',
          'Access-Control-Allow-Origin': '*',
        },
      );
    } catch (e) {
      print('LocalAssetServer: 处理文件时出错: $e');
      return shelf.Response.notFound('未找到资源文件: ${request.url.path}');
    }
  }

  /// MIME 类型探测逻辑，特别增强了对 3D 模型格式的支持
  static String _getMimeType(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    
    if (ext == '.glb') {
      return 'model/gltf-binary';
    } else if (ext == '.gltf') {
      return 'model/gltf+json';
    }
    
    return lookupMimeType(filePath) ?? 'application/octet-stream';
  }

  /// 快捷方法：根据模型文件名生成可访问的完整 URL
  static String getModelUrl(String modelFileName) {
    return '$baseUrl/models/$modelFileName';
  }
}
