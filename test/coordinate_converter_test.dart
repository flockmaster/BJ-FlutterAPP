import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:car_owner_app/core/utils/coordinate_converter.dart';

void main() {
  group('坐标转换测试', () {
    // 测试数据：北京天安门
    const LatLng tianAnMenWgs84 = LatLng(39.9042, 116.4074);
    
    test('WGS84 转 GCJ02 - 天安门', () {
      LatLng gcj02 = CoordinateConverter.wgs84ToGcj02(tianAnMenWgs84);
      
      // 验证转换后的坐标在合理范围内
      expect(gcj02.latitude, greaterThan(39.90));
      expect(gcj02.latitude, lessThan(39.92));
      expect(gcj02.longitude, greaterThan(116.40));
      expect(gcj02.longitude, lessThan(116.42));
      
      // 验证偏移量（约 600 米）
      double distance = CoordinateConverter.calculateDistance(tianAnMenWgs84, gcj02);
      expect(distance, greaterThan(500));
      expect(distance, lessThan(700));
      
      print('WGS84: ${tianAnMenWgs84.latitude}, ${tianAnMenWgs84.longitude}');
      print('GCJ02: ${gcj02.latitude}, ${gcj02.longitude}');
      print('偏移距离: ${distance.toStringAsFixed(2)} 米');
    });
    
    test('WGS84 转 BD09 - 天安门', () {
      LatLng bd09 = CoordinateConverter.wgs84ToBd09(tianAnMenWgs84);
      
      // 验证转换后的坐标在合理范围内
      expect(bd09.latitude, greaterThan(39.90));
      expect(bd09.latitude, lessThan(39.93));
      expect(bd09.longitude, greaterThan(116.40));
      expect(bd09.longitude, lessThan(116.43));
      
      // 验证偏移量（约 1200 米）
      double distance = CoordinateConverter.calculateDistance(tianAnMenWgs84, bd09);
      expect(distance, greaterThan(1000));
      expect(distance, lessThan(1400));
      
      print('WGS84: ${tianAnMenWgs84.latitude}, ${tianAnMenWgs84.longitude}');
      print('BD09: ${bd09.latitude}, ${bd09.longitude}');
      print('偏移距离: ${distance.toStringAsFixed(2)} 米');
    });
    
    test('GCJ02 转 BD09', () {
      LatLng gcj02 = CoordinateConverter.wgs84ToGcj02(tianAnMenWgs84);
      LatLng bd09 = CoordinateConverter.gcj02ToBd09(gcj02);
      
      // 验证 GCJ02 到 BD09 的偏移（约 800 米）
      double distance = CoordinateConverter.calculateDistance(gcj02, bd09);
      expect(distance, greaterThan(700));
      expect(distance, lessThan(1000));
      
      print('GCJ02: ${gcj02.latitude}, ${gcj02.longitude}');
      print('BD09: ${bd09.latitude}, ${bd09.longitude}');
      print('偏移距离: ${distance.toStringAsFixed(2)} 米');
    });
    
    test('往返转换精度 - WGS84 ↔ GCJ02', () {
      LatLng gcj02 = CoordinateConverter.wgs84ToGcj02(tianAnMenWgs84);
      LatLng backToWgs84 = CoordinateConverter.gcj02ToWgs84(gcj02);
      
      // 验证误差小于 10 米
      double error = CoordinateConverter.calculateDistance(tianAnMenWgs84, backToWgs84);
      expect(error, lessThan(10));
      
      print('原始 WGS84: ${tianAnMenWgs84.latitude}, ${tianAnMenWgs84.longitude}');
      print('转换后 WGS84: ${backToWgs84.latitude}, ${backToWgs84.longitude}');
      print('误差: ${error.toStringAsFixed(2)} 米');
    });
    
    test('往返转换精度 - GCJ02 ↔ BD09', () {
      LatLng gcj02 = const LatLng(39.9087, 116.4134);
      LatLng bd09 = CoordinateConverter.gcj02ToBd09(gcj02);
      LatLng backToGcj02 = CoordinateConverter.bd09ToGcj02(bd09);
      
      // 验证误差小于 5 米
      double error = CoordinateConverter.calculateDistance(gcj02, backToGcj02);
      expect(error, lessThan(5));
      
      print('原始 GCJ02: ${gcj02.latitude}, ${gcj02.longitude}');
      print('转换后 GCJ02: ${backToGcj02.latitude}, ${backToGcj02.longitude}');
      print('误差: ${error.toStringAsFixed(2)} 米');
    });
    
    test('中国境外坐标不转换', () {
      // 纽约坐标
      LatLng newYork = const LatLng(40.7128, -74.0060);
      LatLng gcj02 = CoordinateConverter.wgs84ToGcj02(newYork);
      
      // 境外坐标应该保持不变
      expect(gcj02.latitude, equals(newYork.latitude));
      expect(gcj02.longitude, equals(newYork.longitude));
      
      print('纽约 WGS84: ${newYork.latitude}, ${newYork.longitude}');
      print('纽约 GCJ02: ${gcj02.latitude}, ${gcj02.longitude}');
      print('是否相同: ${gcj02 == newYork}');
    });
    
    test('距离计算准确性', () {
      // 天安门到故宫（约 1.6 公里）
      LatLng tianAnMen = const LatLng(39.9042, 116.4074);
      LatLng guGong = const LatLng(39.9163, 116.3972);
      
      double distance = CoordinateConverter.calculateDistance(tianAnMen, guGong);
      
      // 实际距离约 1.6 公里
      expect(distance, greaterThan(1400));
      expect(distance, lessThan(1700));
      
      print('天安门到故宫距离: ${distance.toStringAsFixed(2)} 米');
    });
    
    test('多个城市坐标转换', () {
      // 测试不同城市的转换
      Map<String, LatLng> cities = {
        '北京': const LatLng(39.9042, 116.4074),
        '上海': const LatLng(31.2304, 121.4737),
        '广州': const LatLng(23.1291, 113.2644),
        '深圳': const LatLng(22.5431, 114.0579),
      };
      
      cities.forEach((city, wgs84) {
        LatLng gcj02 = CoordinateConverter.wgs84ToGcj02(wgs84);
        LatLng bd09 = CoordinateConverter.wgs84ToBd09(wgs84);
        
        double gcj02Distance = CoordinateConverter.calculateDistance(wgs84, gcj02);
        double bd09Distance = CoordinateConverter.calculateDistance(wgs84, bd09);
        
        print('$city:');
        print('  WGS84: ${wgs84.latitude}, ${wgs84.longitude}');
        print('  GCJ02: ${gcj02.latitude}, ${gcj02.longitude} (偏移 ${gcj02Distance.toStringAsFixed(0)}m)');
        print('  BD09:  ${bd09.latitude}, ${bd09.longitude} (偏移 ${bd09Distance.toStringAsFixed(0)}m)');
        
        // 验证偏移量在合理范围内
        expect(gcj02Distance, greaterThan(0));
        expect(gcj02Distance, lessThan(1000));
        expect(bd09Distance, greaterThan(0));
        expect(bd09Distance, lessThan(2000));
      });
    });
  });
  
  group('坐标系枚举测试', () {
    test('获取坐标系名称', () {
      expect(
        CoordinateConverter.getCoordinateSystemName(CoordinateSystem.wgs84),
        equals('WGS84 (GPS)'),
      );
      expect(
        CoordinateConverter.getCoordinateSystemName(CoordinateSystem.gcj02),
        equals('GCJ02 (火星坐标)'),
      );
      expect(
        CoordinateConverter.getCoordinateSystemName(CoordinateSystem.bd09),
        equals('BD09 (百度坐标)'),
      );
    });
  });
}
