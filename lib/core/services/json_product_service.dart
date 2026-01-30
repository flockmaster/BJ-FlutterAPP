import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import '../models/store_models.dart';

/// [JsonProductService] - 基于 JSON 文件的商品数据加载服务
/// 
/// 核心职责：
/// 1. 从项目静态资源目录 (`assets/mock_data/`) 中读取并解析商城商品 JSON 数据。
/// 2. 实现内存级别的商品数据缓存，避免重复读取磁盘 Io。
/// 3. 提供按 ID、按分类查询商品及获取分类字典的方法。
@LazySingleton()
class JsonProductService {
  // 缓存原始 JSON 结构，用于分类查找
  Map<String, dynamic>? _cachedData;
  // 缓存解析后的强类型商品模型列表
  List<StoreProduct>? _cachedProducts;
  
  /// 私有加载逻辑：仅在首次请求数据时从 rootBundle 读取文件
  Future<void> _loadData() async {
    if (_cachedData != null) return;
    
    try {
      final jsonString = await rootBundle.loadString('assets/mock_data/store_products.json');
      _cachedData = json.decode(jsonString);
      _cachedProducts = _parseProducts(_cachedData!['products'] as List);
      print('✅ 成功加载 ${_cachedProducts!.length} 个商品数据');
    } catch (e) {
      print('❌ 加载商品数据失败: $e');
      _cachedData = {};
      _cachedProducts = [];
    }
  }
  
  /// 将解析出的动态 List 转换为强类型的 StoreProduct 对象列表
  List<StoreProduct> _parseProducts(List productList) {
    final products = <StoreProduct>[];
    
    for (var json in productList) {
      try {
        final product = StoreProduct(
          id: _parseProductId(json['id']),
          title: json['title'] ?? '',
          description: json['description'],
          price: (json['price'] as num?)?.toDouble() ?? 0.0,
          originalPrice: (json['originalPrice'] as num?)?.toDouble(),
          image: json['image'] ?? '',
          categoryId: null, // JSON 结构中当前未映射 categoryId 到模型
          tags: (json['features'] as List?)?.map((e) => e.toString()).toList(),
          specifications: _parseSpecifications(json['specifications']),
          // 逻辑：积分通常按价格的固定比例换算
          points: ((json['price'] as num?)?.toDouble() ?? 0.0 / 10).floor(),
          stockQuantity: json['stock'] ?? 0,
          salesCount: json['sales'] ?? 0,
          isActive: true,
          // 根据评分自动标记为精选商品
          isFeatured: ((json['rating'] as num?)?.toDouble() ?? 0.0) >= 4.8,
          type: json['type'] ?? 'physical',
          gallery: (json['gallery'] as List?)?.map((e) => e.toString()).toList(),
          detailImages: (json['description_images'] as List?)?.map((e) => e.toString()).toList(),
          createdAt: DateTime.now(),
        );
        products.add(product);
      } catch (e) {
        print('⚠️ 模型解析单项商品失败: $e');
      }
    }
    
    return products;
  }
  
  /// 辅助解析方法：将 JSON 中的字符串 ID (如 "prod_001") 转换为整数 ID
  int _parseProductId(String id) {
    final match = RegExp(r'(\d+)').firstMatch(id);
    return match != null ? int.parse(match.group(1)!) : 0;
  }
  
  /// 解析商品规格 (Specifications) 嵌套结构
  List<ProductSpec>? _parseSpecifications(dynamic specs) {
    if (specs == null) return null;
    
    try {
      final specList = <ProductSpec>[];
      for (var spec in specs as List) {
        final options = <ProductSpecOption>[];
        for (var opt in spec['options'] as List) {
          options.add(ProductSpecOption(
            value: opt['value'] ?? '',
            label: opt['label'] ?? '',
            priceMod: (opt['priceMod'] as num?)?.toDouble() ?? 0.0,
          ));
        }
        
        specList.add(ProductSpec(
          id: spec['id'] ?? '',
          name: spec['name'] ?? '',
          options: options,
        ));
      }
      return specList;
    } catch (e) {
      print('⚠️ 规格数据格式错误，解析失败: $e');
      return null;
    }
  }
  
  /// 公开接口：获取所有商城商品
  Future<List<StoreProduct>> getAllProducts() async {
    await _loadData();
    return _cachedProducts ?? [];
  }
  
  /// 公开接口：通过整型 ID 检索单个商品详情
  Future<StoreProduct?> getProductById(int id) async {
    await _loadData();
    try {
      return _cachedProducts?.firstWhere((p) => p.id == id);
    } catch (e) {
      print('⚠️ 未能在缓存中找到商品 ID: $id');
      return null;
    }
  }
  
  /// 按分类 ID 过滤商品
  Future<List<StoreProduct>> getProductsByCategory(String categoryId) async {
    await _loadData();
    
    final products = _cachedData?['products'] as List? ?? [];
    final filtered = products.where((p) => p['categoryId'] == categoryId).toList();
    
    return _parseProducts(filtered);
  }
  
  /// 获取分类字典 (CategoryID -> CategoryName)
  Future<Map<String, String>> getCategories() async {
    await _loadData();
    final categories = _cachedData?['categories'] as Map<String, dynamic>? ?? {};
    return categories.map((key, value) => MapEntry(key, value.toString()));
  }
}
