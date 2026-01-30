import 'package:flutter/material.dart'; // Keep for Color/WebViewController usage
import 'package:webview_flutter/webview_flutter.dart';
import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import '../../../core/services/local_asset_server.dart';

class VRExperienceEnhancedViewModel extends BaicBaseViewModel {
  final String carName;
  final String? modelAssetPath;

  late WebViewController webViewController;

  VRExperienceEnhancedViewModel({
    required this.carName,
    this.modelAssetPath,
  });

  bool _isWebViewReady = false;
  bool get isWebViewReady => _isWebViewReady;

  bool _isAutoRotate = true;
  bool get isAutoRotate => _isAutoRotate;

  int _selectedColorIndex = 0;
  int get selectedColorIndex => _selectedColorIndex;

  String? _modelUrl;
  String? get modelUrl => _modelUrl;

  // 核心配色方案：橙色 + 三种常见色
  final List<Map<String, dynamic>> carColors = [
    {'name': '熔岩橙', 'hex': const Color(0xFFFF6B00), 'rgb': [255, 107, 0]},
    {'name': '极夜黑', 'hex': const Color(0xFF1A1A1A), 'rgb': [26, 26, 26]},
    {'name': '雪域白', 'hex': Colors.white, 'rgb': [255, 255, 255]},
    {'name': '太空银', 'hex': const Color(0xFFA5A5A5), 'rgb': [165, 165, 165]},
  ];

  Future<void> init() async {
    setBusy(true);
    
    // 确保本地服务器已启动
    if (!LocalAssetServer.isRunning) {
      await LocalAssetServer.start();
    }
    
    // 获取模型URL
    if (modelAssetPath != null) {
      // 从assets路径提取文件名
      final fileName = modelAssetPath!.split('/').last;
      _modelUrl = LocalAssetServer.getModelUrl(fileName);
      print('Model URL: $_modelUrl');
    }
    
    await _initWebView();
  }

  Future<void> _initWebView() async {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF5F7FA))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            // Wait a bit for model-viewer to initialize
            await Future.delayed(const Duration(milliseconds: 1500));
            _isWebViewReady = true;
            setBusy(false);
            notifyListeners();
            
            // Apply initial color
            await applyColor(0);
          },
          onWebResourceError: (error) {
            print('WebView Error: ${error.description}');
          },
        ),
      );

    // Load HTML with model-viewer
    final htmlContent = await _getHtmlContent();
    await webViewController.loadHtmlString(htmlContent);
  }

  Future<String> _getHtmlContent() async {
    // 使用本地服务器URL
    final modelSrc = _modelUrl ?? 'http://127.0.0.1:8080/BJ40-V1.glb';
    
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <script type="module" src="https://ajax.googleapis.com/ajax/libs/model-viewer/3.4.0/model-viewer.min.js"></script>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      width: 100vw;
      height: 100vh;
      background: linear-gradient(180deg, #E5E7EB 0%, #F5F7FA 100%);
      overflow: hidden;
    }
    model-viewer {
      width: 100%;
      height: 100%;
      --poster-color: transparent;
    }
  </style>
</head>
<body>
  <model-viewer
    id="carModel"
    src="\$modelSrc"
    alt="3D Car Model"
    auto-rotate
    camera-controls
    shadow-intensity="2"
    exposure="1"
    environment-image="neutral"
    touch-action="pan-y">
  </model-viewer>

  <script>
    const modelViewer = document.querySelector('#carModel');
    
    // Function to apply color to car body materials
    window.applyCarColor = function(r, g, b) {
      if (!modelViewer.model) {
        console.log('Model not loaded yet');
        return;
      }
      
      const rgba = [r / 255, g / 255, b / 255, 1.0];
      let colorApplied = false;
      
      modelViewer.model.materials.forEach((material) => {
        const name = material.name.toLowerCase();
        const isPaint = name.includes('paint') || 
                       name.includes('body') || 
                       name.includes('car_color') || 
                       name.includes('exterior') || 
                       name.includes('shell') ||
                       name.includes('mat'); // 添加通用材质名
        const isGlass = name.includes('glass') || name.includes('window');
        
        if (isPaint && !isGlass) {
          material.pbrMetallicRoughness.setBaseColorFactor(rgba);
          colorApplied = true;
          console.log('Applied color to:', name);
        }
      });
      
      // Fallback: apply to metallic materials
      if (!colorApplied) {
        modelViewer.model.materials.forEach((material) => {
          const mr = material.pbrMetallicRoughness;
          if (mr.metallicFactor > 0.3 && 
              !material.name.toLowerCase().includes('glass')) {
            mr.setBaseColorFactor(rgba);
            console.log('Applied color to metallic material:', material.name);
          }
        });
      }
    };
    
    // Function to toggle auto-rotate
    window.toggleAutoRotate = function(enabled) {
      if (enabled) {
        modelViewer.setAttribute('auto-rotate', '');
      } else {
        modelViewer.removeAttribute('auto-rotate');
      }
    };
    
    // Notify when model is loaded
    modelViewer.addEventListener('load', () => {
      console.log('✅ Model loaded successfully');
      console.log('Materials:', modelViewer.model.materials.map(m => m.name));
    });
    
    modelViewer.addEventListener('error', (event) => {
      console.error('❌ Model loading error:', event);
    });
  </script>
</body>
</html>
    ''';
  }

  void toggleAutoRotate() {
    _isAutoRotate = !_isAutoRotate;
    notifyListeners();
    
    // Call JavaScript function
    webViewController.runJavaScript(
      'window.toggleAutoRotate($_isAutoRotate);'
    );
  }

  Future<void> selectColor(int index) async {
    _selectedColorIndex = index;
    notifyListeners();
    
    await applyColor(index);
  }

  Future<void> applyColor(int index) async {
    final color = carColors[index]['rgb'] as List<int>;
    final r = color[0];
    final g = color[1];
    final b = color[2];
    
    try {
      await webViewController.runJavaScript(
        'window.applyCarColor($r, $g, $b);'
      );
      print('Applied color: R=$r, G=$g, B=$b');
    } catch (e) {
      print('Error applying color: $e');
    }
  }
  
  @override
  void dispose() {
    // 不要在这里停止服务器，因为可能有其他页面在使用
    super.dispose();
  }
}
