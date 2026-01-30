import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

/// [ICacheService] - 缓存管理服务接口
/// 
/// 负责监控和清理应用在运行过程中产生的临时文件和图片缓存，以优化存储占用。
abstract class ICacheService {
  /// 计算当前应用的缓存占用大小
  /// 返回格式化后的字符串（如："12.5 MB"）
  Future<String> getCacheSize();
  
  /// 彻底清空所有应用层面的临时缓存文件
  Future<void> clearCache();
}

/// [CacheService] - 缓存服务具体实现
/// 
/// 核心逻辑：
/// 1. 使用 [DefaultCacheManager] 管理网络图片等资源的自动缓存。
/// 2. 手动遍历 [getTemporaryDirectory] 下的相关子目录进行全量统计与删除。
@LazySingleton(as: ICacheService)
class CacheService implements ICacheService {
  // 持有缓存管理器引用
  final DefaultCacheManager _cacheManager = DefaultCacheManager();

  @override
  Future<String> getCacheSize() async {
    try {
      int totalSize = 0;
      
      // 定位临时目录中存放缓存图片的位置
      final tempDir = await getTemporaryDirectory();
      final cacheDir = Directory('${tempDir.path}/libCachedImageData');
      
      if (await cacheDir.exists()) {
        // 递归遍历所有文件并累加长度
        await for (var file in cacheDir.list(recursive: true, followLinks: false)) {
          if (file is File) {
            totalSize += await file.length();
          }
        }
      }
      
      return _formatSize(totalSize);
    } catch (e) {
      print('计算缓存大小时出错: $e');
      return '0 B';
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      // 1. 调用缓存管理器自身的清空方法
      await _cacheManager.emptyCache();
      
      // 2. 为了保险起见，手动删除存放图片的文件夹
      final tempDir = await getTemporaryDirectory();
      final cacheDir = Directory('${tempDir.path}/libCachedImageData');
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
    } catch (e) {
      print('清空缓存时出错: $e');
    }
  }

  /// 工具方法：将字节数转换为人类可读的格式 (B, KB, MB, GB)
  String _formatSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }
}
