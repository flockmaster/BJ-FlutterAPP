import 'package:injectable/injectable.dart';
import '../models/car_model.dart';

/// [IHelpCenterService] - 帮助中心与百科服务接口
/// 
/// 负责提供：各车型手册列表、常见问题 (FAQ) 库、以及用户生命周期说明数据。
abstract class IHelpCenterService {
  /// 获取支持的所有车型的基本模型（用于展示手册封面）
  Future<List<CarModel>> getCarModels();
  
  /// 获取常见问题列表，按分类聚合
  /// 返回格式：{ "分类标识": ["问题1", "问题2"] }
  Future<Map<String, List<String>>> getFAQs();
  
  /// 获取车主生命周期阶段（如：看车、提车、用车、售后）
  List<LifecycleStage> getLifecycleStages();
}

/// [HelpCenterService] - 帮助中心服务具体实现
@LazySingleton(as: IHelpCenterService)
class HelpCenterService implements IHelpCenterService {
  @override
  Future<List<CarModel>> getCarModels() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      const CarModel(
        id: 'BJ40',
        modelKey: 'bj40',
        name: 'BJ40',
        fullName: '越野世家 BJ40',
        subtitle: '横贯华夏 越野之王',
        price: 13.98,
        backgroundImage: 'https://i.imgs.ovh/2025/12/23/CpkkOO.webp',
      ),
      const CarModel(
        id: 'BJ60',
        modelKey: 'bj60',
        name: 'BJ60',
        fullName: '越野世家 BJ60',
        subtitle: '硬核家轿 极致舒适',
        price: 23.98,
        backgroundImage: 'https://i.imgs.ovh/2025/12/23/CpkkOO.webp',
      ),
      const CarModel(
        id: 'BJ30',
        modelKey: 'bj30',
        name: 'BJ30',
        fullName: '越野世家 BJ30',
        subtitle: '轻量化越野新宠',
        price: 9.98,
        backgroundImage: 'https://i.imgs.ovh/2025/12/23/CpkkOO.webp',
      ),
    ];
  }

  @override
  Future<Map<String, List<String>>> getFAQs() async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    return {
      'buy': [
        'BJ40 不同版本有什么区别？',
        '现在的购车优惠政策有哪些？',
        '如何预约到店试驾？',
        '置换补贴的流程是怎样的？',
      ],
      'delivery': [
        '提车时需要带什么证件？',
        '如何激活车联网服务？',
        '新车磨合期需要注意什么？',
        '验车流程及注意事项',
      ],
      'use': [
        '如何使用分时四驱系统？',
        '胎压监测报警如何处理？',
        '车机系统如何升级 (OTA)？',
        '定速巡航功能使用说明',
      ],
      'service': [
        '保养周期和费用是多少？',
        '道路救援电话是多少？',
        '配件保修政策说明',
        '如何查询附近的维修网点？',
      ],
    };
  }

  @override
  List<LifecycleStage> getLifecycleStages() {
    return [
      LifecycleStage(id: 'buy', label: '看车选购'),
      LifecycleStage(id: 'delivery', label: '新车提取'),
      LifecycleStage(id: 'use', label: '用车指南'),
      LifecycleStage(id: 'service', label: '售后维保'),
    ];
  }
}

/// [LifecycleStage] - 生命周期阶段模型
class LifecycleStage {
  final String id;
  final String label;

  LifecycleStage({
    required this.id,
    required this.label,
  });
}
