import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:yaml/yaml.dart';
import 'package:dio/dio.dart';
import '../utils/yolo_decoder.dart';

/// 故障等级
enum FaultSeverity {
  critical, // 红色：高危
  warning,  // 黄色：警告
  info,     // 提示
  unknown,
}

/// 故障颜色
enum FaultColor {
  red,
  yellow,
  green,
  unknown,
}

/// 故障项模型
/// 用于描述检测到的单个故障指示灯或系统异常状态
class FaultItem {
  final String id; // 唯一标识符（由车辆状态和时间戳生成）
  final String name; // 故障名称（如：发动机系统故障）
  final String description; // 详细的技术分析描述
  final FaultSeverity severity; // 故障严重等级
  final FaultColor detectedColor; // 指示灯颜色（红/黄/绿）
  final String advice; // 针对该故障的驾驶建议
  final double confidence; // AI 识别置信度 (0.0 - 1.0)
  final List<double> bbox; // 坐标信息（在线模型目前返回空，本地模型使用）

  FaultItem({
    required this.id,
    required this.name,
    required this.description,
    required this.severity,
    required this.detectedColor,
    required this.advice,
    required this.confidence,
    required this.bbox,
  });
}

/// 诊断报告模型
/// 包含本次分析识别出的所有故障项及综合汇总信息
class DiagnosisReport {
  final List<FaultItem> items; // 识别出的故障列表
  final bool isSelfCheckSuspected; // 是否疑似处于仪表盘自检状态
  final String summary; // 诊断结果的文字汇总叙述

  DiagnosisReport({
    required this.items,
    required this.isSelfCheckSuspected,
    required this.summary,
  });
}

/// 核心服务：仪表盘故障智能识别与诊断服务
/// 遵循铁律 7：所有数据交互必须通过 ApiClient (此处使用 Dio 调用 OpenRouter 视觉大模型)
/// 
/// 核心逻辑：
/// 1. 接收拍摄的仪表盘照片
/// 2. 进行图片预处理（压缩、调整尺寸以符合 API 限制）
/// 3. 调用 OpenRouter Qwen2.5-VL 视觉大模型
/// 4. 根据转速（RPM）和指示灯数量综合判定：自检、静态故障还是行驶中故障
class FaultDetectionService {
  // Interpreter? _interpreter;
  // YoloDecoder? _decoder;
  
  // 状态变量
  List<String> _labels = []; // 存储本地模型的标签（目前基于在线模型，暂不使用）
  Map<String, dynamic> _knowledgeBase = {}; // 本地知识库（由 assets/fault_knowledge.json 加载）
  bool _isModelLoaded = true; // 在线模型默认视为已就绪
  
  // OpenRouter 相关配置：对接视觉多模态大模型
  static const String _apiKey = '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';
  static const String _baseUrl = 'https://openrouter.ai/api/v1/';
  static const String _model = 'qwen/qwen2.5-vl-72b-instruct:free'; // 使用阿里 Qwen2.5-VL 免费版

  static const String _prompt = """
# 角色定位
你是一位经验丰富的汽车诊断顾问，擅长用**简洁专业**的语言向车主解释仪表盘状态。

# 判断流程（严格按顺序执行）

## Step 1: 观察转速表
- 仔细查看转速表(RPM/r/min)的指针位置
- **如果指针指向0或接近0** → 车辆未启动（钥匙在ON档或ACC档）
- **如果指针明显大于0**（如500-8000转） → 发动机已启动

## Step 2: 统计故障灯数量
数一数仪表盘上**同时亮起的故障指示灯总数**（不论颜色）:
- 机油灯、电瓶灯、发动机故障灯、胎压灯、刹车灯、ABS灯、安全带灯等

## Step 3: 综合判定车辆状态（核心逻辑）

### 情况A：转速 = 0 且 故障灯数量 ≥ 3个
**→ 判定为「自检中」**  
- 原因：车辆刚通电时会进行仪表盘自检，所有传感器会模拟故障状态，导致多个灯同时点亮
- 这是**正常现象**，不是真实故障

### 情况B：转速 = 0 且 故障灯数量 = 1-2个
**→ 判定为「静态故障提示」**  
- 原因：仅个别灯亮起，说明存在特定的静态问题（如真的胎压低、车门未关等）
- 这是**真实故障**，需要处理

### 情况C：转速 > 0 且 有任何故障灯亮起
**→ 判定为「行驶中故障」**  
- 原因：发动机已启动，正常情况下故障灯应该熄灭，若仍亮起则是真实故障
- 这是**紧急情况**，需立即处理

## 特别强调（防止错误判断）
❌ **错误示范**: 转速0 + 发动机灯+胎压灯+刹车灯(3个) → 判定为"静态故障提示"  
✅ **正确判断**: 转速0 + 发动机灯+胎压灯+刹车灯(3个) → **必须判定为「自检中」**

# 输出格式（纯JSON，不要包含任何Markdown标记）

{
    "is_valid": true,
    "vehicle_state": "自检中 或 静态故障提示 或 行驶中故障",
    "fault_names": "用专业术语描述故障（如：发动机系统故障、胎压监测异常、制动系统警告）",
    "system_category": "系统分类（如：发动机系统、底盘系统、多系统自检）",
    "severity_label": "提示 或 警告 或 危险",
    "technical_analysis": "用简洁、专业的语言描述诊断结果，要求：
    1. 说明车辆当前状态（如：车辆正在行驶中 / 车辆处于通电未启动状态 / 系统正在进行自检）
    2. 描述检测到的故障灯（使用专业名称，如：发动机故障灯（黄色）、胎压监测警告灯（红色））
    3. 给出简要诊断结论（如：发动机系统可能存在异常 / 轮胎气压低于标准值 / 仪表盘自检正常）
    4. 保持专业但易懂，避免过度技术化的描述
    示例（自检）：'系统正在进行仪表盘自检，检测到发动机故障灯、电瓶指示灯、机油压力警告灯等多个指示灯同时点亮。这是车辆通电后的正常自检程序，启动后将自动熄灭。'
    示例（行驶故障）：'车辆正在行驶中，检测到发动机故障灯（黄色）亮起。这表明发动机系统可能存在异常，建议尽快靠边检查或前往服务站诊断。'
    示例（静态故障）：'车辆处于通电未启动状态，检测到胎压监测警告灯亮起。这提示轮胎气压可能低于标准值，建议启动前检查四轮胎压。'",
    "driving_suggestion": "给出专业、具体的建议（如：建议立即前往最近的授权服务站进行系统诊断 / 请检查四轮胎压并充气至标准值 / 这是正常的自检程序，无需处理）",
    "confidence_score": "95%"
}

# 关键要求
1. **转速和数量是判定依据**：先看转速，再数灯，然后套用上述规则
2. **禁止编造**：所有内容必须基于图片真实观察，不得虚构数据
3. **禁止格式标记**：不要输出```json或其他Markdown格式，直接返回纯JSON
4. **专业简洁并重**：使用准确的汽车术语，但表达要简洁明了，避免冗长的技术描述
5. **无法识别时**：如果图片模糊或不是仪表盘，返回 "is_valid": false
""";

  // static const int _selfCheckThreshold = 3;
  // static const int _inputSize = 640; 

  /// 服务初始化
  /// 在切入在线模型后，本地逻辑暂处于屏蔽状态，后期可作为备选优化方案（边缘端识别）
  Future<void> initialize() async {
    /* 切换到在线大模型，本地初始化暂时屏蔽
    if (_isModelLoaded) return;

    try {
      // 1. Load Labels
      final yamlString = await rootBundle.loadString('assets/data.yaml');
      final yamlMap = loadYaml(yamlString);
      if (yamlMap['names'] is List) {
        _labels = List<String>.from(yamlMap['names']);
      }

      // 2. Load Knowledge Base
      final jsonString = await rootBundle.loadString('assets/fault_knowledge.json');
      _knowledgeBase = jsonDecode(jsonString);

      // 3. Load TFLite Model (CPU)
      final options = InterpreterOptions()..threads = 3;
      _interpreter = await Interpreter.fromAsset('assets/best_float16.tflite', options: options);
      
      // Init Decoder
      _decoder = YoloDecoder(labels: _labels, confThreshold: 0.15); 
      
      _isModelLoaded = true;
      print('[FaultDetectionService] TFLite Interpreter loaded successfully');
    } catch (e) {
      print('[FaultDetectionService] Init failed: $e');
      _isModelLoaded = false;
    }
    */
  }

  /// Helper: Check model readiness
  bool get isReady => _isModelLoaded;

  /// 核心分析方法：分析拍摄的仪表盘图像
  /// 逻辑：图片压缩 -> 转 Base64 -> API 调用 -> JSON 解析与封装
  Future<DiagnosisReport> analyzeImage(XFile imageFile) async {
    print('[FaultDetectionService] 开始分析图片: ${imageFile.path}');
    
    // 采用在线 API 识别逻辑 (多模态视觉)
    try {
      // 1. 读取原始字节
      final bytes = await imageFile.readAsBytes();
      print('[FaultDetectionService] 原始图片字节大小: ${bytes.length}');

      // 2. 图像压缩策略：视觉模型对分辨率有上限要求，且需节省带宽
      img.Image? originalImage = img.decodeImage(bytes);
      if (originalImage == null) throw Exception("无法解析图片数据");

      // 限制最大宽度为 1024 像素，保持原始比例
      img.Image resizedImage;
      if (originalImage.width > 1024) {
        resizedImage = img.copyResize(originalImage, width: 1024);
      } else {
        resizedImage = originalImage;
      }
      
      // 编码为 JPG，保持 85% 质量以平衡清晰度与体积
      final compressedBytes = img.encodeJpg(resizedImage, quality: 85);
      print('[FaultDetectionService] 压缩后图片字节大小: ${compressedBytes.length}');
      
      final base64Image = base64Encode(compressedBytes);

      // 3. 配置 HTTP 客户端 (Dio)
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 45), // 视觉模型推理较慢，需足够超时时间
        receiveTimeout: const Duration(seconds: 45),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://baic.com',
          'X-Title': 'BAIC Car Owner App',
        },
      ));

      const String fullUrl = 'https://openrouter.ai/api/v1/chat/completions';
      print('[FaultDetectionService] 发送 API 请求到: $fullUrl');
      
      // 4. 发起请求：包含 Prompt 文本与图片 Base64
      final response = await dio.post(fullUrl, data: {
        'model': _model,
        'messages': [
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': _prompt},
              {
                'type': 'image_url',
                'image_url': {'url': 'data:image/jpeg;base64,$base64Image'}
              },
            ],
          }
        ],
        'temperature': 0.2, // 低温参数确保识别结果的稳定性与逻辑严密性
        'frequency_penalty': 0.1,
      });

      if (response.statusCode == 200) {
        final content = response.data['choices'][0]['message']['content'] as String;
        print('[FaultDetectionService] API 原始响应: $content');
        
        // 5. 结果解析与后处理
        try {
          // 清理可能存在的 Markdown 代码块包裹逻辑（鲁棒性处理）
          String cleanJson = content.trim();
          if (cleanJson.startsWith('```json')) {
            cleanJson = cleanJson.substring(7);
          }
          if (cleanJson.startsWith('```')) {
            cleanJson = cleanJson.substring(3);
          }
          if (cleanJson.endsWith('```')) {
            cleanJson = cleanJson.substring(0, cleanJson.length - 3);
          }
          cleanJson = cleanJson.trim();
          print('[FaultDetectionService] 清理后的 JSON: $cleanJson');

          final data = jsonDecode(cleanJson);
          
          // 处理无效图片情况
          if (data['is_valid'] == false) {
            print('[FaultDetectionService] AI 判定图片无效: ${data['technical_analysis']}');
            return _createFailureReport("图片不清晰或不是仪表盘，请重新拍摄。");
          }

          // 解析车辆状态与严重等级
          final bool isSelfCheck = data['vehicle_state'] == '自检中';
          final String severityLabel = data['severity_label'] ?? '提示';
          
          FaultSeverity severity = FaultSeverity.info;
          FaultColor color = FaultColor.green;

          if (severityLabel.contains('危险')) {
            severity = FaultSeverity.critical;
            color = FaultColor.red;
          } else if (severityLabel.contains('警告')) {
            severity = FaultSeverity.warning;
            color = FaultColor.yellow;
          }

          final String confidenceStr = data['confidence_score']?.toString().replaceAll('%', '') ?? '100';
          final double confidence = (double.tryParse(confidenceStr) ?? 100.0) / 100.0;

          // 生成基于业务含义的故障唯一 ID
          final String faultId = _generateFaultId(
            data['vehicle_state'] ?? 'unknown',
            data['fault_names'] ?? 'unknown_fault',
          );

          final item = FaultItem(
            id: faultId,
            name: data['fault_names'] ?? '检测到异常',
            description: data['technical_analysis'] ?? '',
            severity: severity,
            detectedColor: color,
            advice: data['driving_suggestion'] ?? '',
            confidence: confidence,
            bbox: [], 
          );
          
          print('[FaultDetectionService] 识别成功: ${item.name} (${item.severity})');

          return DiagnosisReport(
            items: [item],
            isSelfCheckSuspected: isSelfCheck,
            summary: data['technical_analysis'] ?? '',
          );
        } catch (e) {
          print('[FaultDetectionService] JSON 解析错误: $e');
          return _createFailureReport("AI 解析返回结果失败: $e");
        }
      } else {
        print('[FaultDetectionService] API 请求失败: ${response.statusCode} - ${response.data}');
        return _createFailureReport("连接 AI 服务失败 (${response.statusCode})");
      }

    } catch (e) {
      print('[FaultDetectionService] 捕获异常: $e');
      return _createFailureReport("分析出错: $e");
    }
    
    /* 本地模型原始逻辑
    if (!isReady) await initialize();
    if (!isReady) return _createFailureReport("AI模型加载失败");

    try {
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final img.Image? decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) throw Exception("Image decode failed");

      final img.Image resized = img.copyResize(decodedImage, width: _inputSize, height: _inputSize);
      
      var input = List.generate(1, (_) => 
         List.generate(_inputSize, (y) => 
            List.generate(_inputSize, (x) {
                var p = resized.getPixel(x, y);
                return [p.r / 255.0, p.g / 255.0, p.b / 255.0];
            })
         )
      );

      var outputTensor = _interpreter!.getOutputTensor(0);
      var shape = outputTensor.shape; 
      
      var output = List.filled(shape[0], 
         List.filled(shape[1], 
            List.filled(shape[2], 0.0)
         )
      );
      
      _interpreter!.run(input, output);

      final detections = _decoder!.decode(output, decodedImage.width, decodedImage.height);
      
      List<FaultItem> confirmedFaults = [];
      for (var det in detections) {
        String tag = det['tag'];
        List<double> box = List<double>.from(det['box']); 
        double conf = box[4];
        
        double scaleX = decodedImage.width / _inputSize;
        double scaleY = decodedImage.height / _inputSize;
        
        int x1 = (box[0] * scaleX).toInt();
        int y1 = (box[1] * scaleY).toInt();
        int x2 = (box[2] * scaleX).toInt();
        int y2 = (box[3] * scaleY).toInt();

        FaultColor color = _extractColorFromBox(decodedImage, x1, y1, x2, y2);
        
        var item = _createFaultItem(tag, color, conf, box);
        if (item != null) confirmedFaults.add(item);
      }
      
      confirmedFaults.sort((a, b) {
        if (a.severity == FaultSeverity.critical && b.severity != FaultSeverity.critical) return -1;
        if (a.severity != FaultSeverity.critical && b.severity == FaultSeverity.critical) return 1;
        return 0;
      });
      
      bool isSelfCheck = confirmedFaults.length >= _selfCheckThreshold;
      String summary = isSelfCheck 
          ? "疑似车辆自检中（${confirmedFaults.length}个指示灯）。"
          : (confirmedFaults.isEmpty ? "未检测到已知故障灯。" : "发现 ${confirmedFaults.length} 个异常项");

      return DiagnosisReport(items: confirmedFaults, isSelfCheckSuspected: isSelfCheck, summary: summary);

    } catch (e) {
      return _createFailureReport("分析出错: $e");
    }
    */
  }

  FaultItem? _createFaultItem(String tag, FaultColor color, double conf, List<double> box) {
    // 简单查表，如果知识库没有该标签则按未知处理
    final info = _knowledgeBase[tag];
    if (info == null) {
      // 用于调试：如果知识库不全，暂时返回通用对象
      // return null; 
       return FaultItem(
        id: '${tag}_${DateTime.now().millisecondsSinceEpoch}',
        name: tag,
        description: '检测到异常，但知识库中未找到详细说明',
        severity: FaultSeverity.info,
        detectedColor: color,
        advice: '请参考用户手册',
        confidence: conf,
        bbox: box,
      );
    }
    
    // 判定严重等级
    FaultSeverity severity = FaultSeverity.info;
    if (info['severity'] == 'critical') severity = FaultSeverity.critical;
    else if (info['severity'] == 'warning') severity = FaultSeverity.warning;
    else if (color == FaultColor.red) severity = FaultSeverity.critical;
    else if (color == FaultColor.yellow) severity = FaultSeverity.warning;

    return FaultItem(
      id: '${tag}_${DateTime.now().millisecondsSinceEpoch}',
      name: info['name'] ?? tag,
      description: info['description'] ?? '',
      severity: severity,
      detectedColor: color,
      advice: info['advice'] ?? '',
      confidence: conf,
      bbox: box,
    );
  }
  
  
  /// 生成有意义的故障ID
  String _generateFaultId(String vehicleState, String faultNames) {
    // 将车辆状态转换为简短标识
    String statePrefix = '';
    if (vehicleState.contains('自检')) {
      statePrefix = 'self_check';
    } else if (vehicleState.contains('静态')) {
      statePrefix = 'static';
    } else if (vehicleState.contains('行驶')) {
      statePrefix = 'driving';
    } else {
      statePrefix = 'unknown';
    }
    
    // 使用时间戳确保唯一性
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${statePrefix}_$timestamp';
  }
  
  DiagnosisReport _createFailureReport(String msg) {
    return DiagnosisReport(items: [], isSelfCheckSuspected: false, summary: msg);
  }

  /// 备用逻辑：从图像选定区域提取颜色
  /// 该逻辑在切回本地 TFLite 模型识别 BBox 时非常有用
  FaultColor _extractColorFromBox(img.Image fullImage, int x1, int y1, int x2, int y2) {
       x1 = x1.clamp(0, fullImage.width - 1);
       x2 = x2.clamp(0, fullImage.width - 1);
       y1 = y1.clamp(0, fullImage.height - 1);
       y2 = y2.clamp(0, fullImage.height - 1);
       
       if (x2 <= x1 || y2 <= y1) return FaultColor.unknown;

       final cropped = img.copyCrop(fullImage, x: x1, y: y1, width: x2 - x1, height: y2 - y1);
       
       int rC = 0;
       int yC = 0;
       int total = 0;
       
       for (final p in cropped) {
          double r = p.r / 255.0;
          double g = p.g / 255.0;
          double b = p.b / 255.0;
          
          double maxV = [r, g, b].reduce(max);
          double minV = [r, g, b].reduce(min);
          double delta = maxV - minV;
          
          if (maxV < 0.3) continue; 
          if (delta < 0.1) continue; 

          double h = 0;
          if (delta == 0) {
             h = 0;
          } else if (maxV == r) {
             h = (g - b) / delta % 6;
          } else if (maxV == g) {
             h = (b - r) / delta + 2;
          } else {
             h = (r - g) / delta + 4;
          }
          
          h *= 60;
          if (h < 0) h += 360;
          
          if (h >= 330 || h <= 25) {
             rC++;
          } else if (h > 25 && h < 70) {
             yC++;
          }
          total++;
       }
       if (total == 0) return FaultColor.unknown;
      
      double redRatio = rC / total;
      double yellowRatio = yC / total;

      const double threshold = 0.02;

      if (redRatio > threshold && redRatio > yellowRatio) return FaultColor.red;
      if (yellowRatio > threshold && yellowRatio > redRatio) return FaultColor.yellow;
      
      if (redRatio > 0.01 && yellowRatio > 0.01) {
          return redRatio > yellowRatio ? FaultColor.red : FaultColor.yellow;
      }

      return FaultColor.unknown;
  }
  
  Future<void> dispose() async {
    // _interpreter?.close();
  }
}
