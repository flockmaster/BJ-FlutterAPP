import 'package:flutter/material.dart';
import 'dart:math' as math;

class MedalWidget extends StatelessWidget {
  final int id;
  final bool grayscale;
  final double size;

  const MedalWidget({
    super.key,
    required this.id,
    this.grayscale = false,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: MedalPainter(
        id: id,
        grayscale: grayscale,
      ),
    );
  }
}

class MedalPainter extends CustomPainter {
  final int id;
  final bool grayscale;

  MedalPainter({
    required this.id,
    required this.grayscale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 200; // 原始设计是 200x200

    // 绘制外框（五边形）
    _drawOuterFrame(canvas, center, scale);

    // 绘制勋章内容
    _drawMedalContent(canvas, center, scale);

    // 绘制光泽效果
    _drawGloss(canvas, center, scale);

    // 如果是灰度，添加灰度滤镜
    if (grayscale) {
      final grayPaint = Paint()
        ..color = Colors.white.withOpacity(0.6)
        ..blendMode = BlendMode.saturation;
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        grayPaint,
      );
    }
  }

  void _drawOuterFrame(Canvas canvas, Offset center, double scale) {
    // 外框五边形路径
    final outerPath = Path();
    final outerPoints = _getPentagonPoints(center, 95 * scale, -math.pi / 2);
    outerPath.moveTo(outerPoints[0].dx, outerPoints[0].dy);
    for (int i = 1; i < outerPoints.length; i++) {
      outerPath.lineTo(outerPoints[i].dx, outerPoints[i].dy);
    }
    outerPath.close();

    // 填充黑色背景
    final bgPaint = Paint()
      ..color = const Color(0xFF333333)
      ..style = PaintingStyle.fill;
    canvas.drawPath(outerPath, bgPaint);

    // 渐变边框
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: grayscale
          ? [
              const Color(0xFFB2BEC3),
              const Color(0xFF95A5A6),
              const Color(0xFF7F8C8D),
            ]
          : [
              const Color(0xFFFAD390),
              const Color(0xFFE58E26),
              const Color(0xFFB33939),
            ],
    );

    final borderPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: 95 * scale),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10 * scale;
    canvas.drawPath(outerPath, borderPaint);
  }

  void _drawMedalContent(Canvas canvas, Offset center, double scale) {
    // 内部五边形背景
    final innerPath = Path();
    final innerPoints = _getPentagonPoints(center, 80 * scale, -math.pi / 2);
    innerPath.moveTo(innerPoints[0].dx, innerPoints[0].dy);
    for (int i = 1; i < innerPoints.length; i++) {
      innerPath.lineTo(innerPoints[i].dx, innerPoints[i].dy);
    }
    innerPath.close();

    Color fillColor;
    switch (id) {
      case 1:
        fillColor = const Color(0xFF6C5CE7); // 紫色 - 持之以恒
        break;
      case 2:
        fillColor = const Color(0xFF0984E3); // 蓝色 - 越野新秀
        break;
      case 3:
        fillColor = const Color(0xFFF1C40F); // 黄色 - 活跃达人
        break;
      case 4:
        fillColor = const Color(0xFFE74C3C); // 红色 - 进藏英雄
        break;
      case 5:
        fillColor = const Color(0xFFE67E22); // 橙色 - 阿拉善之星
        break;
      case 6:
        fillColor = const Color(0xFF27AE60); // 绿色 - 金牌改装
        break;
      default:
        fillColor = const Color(0xFFB2BEC3); // 灰色
    }

    if (grayscale) {
      fillColor = const Color(0xFFB2BEC3);
    }

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(innerPath, fillPaint);

    // 绘制图案
    _drawPattern(canvas, center, scale);

    // 绘制等级标记
    _drawLevelMarker(canvas, center, scale);
  }

  void _drawPattern(Canvas canvas, Offset center, double scale) {
    final whitePaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    switch (id) {
      case 1: // 持之以恒 - 日历/打卡图案
        // 绘制日历框
        final calendarRect = RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: 50 * scale, height: 50 * scale),
          Radius.circular(8 * scale),
        );
        canvas.drawRRect(calendarRect, whitePaint);
        
        // 绘制打勾
        final checkPath = Path();
        checkPath.moveTo(center.dx - 12 * scale, center.dy);
        checkPath.lineTo(center.dx - 4 * scale, center.dy + 8 * scale);
        checkPath.lineTo(center.dx + 12 * scale, center.dy - 8 * scale);
        canvas.drawPath(
          checkPath,
          Paint()
            ..color = const Color(0xFF6C5CE7)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5 * scale
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );
        break;

      case 2: // 越野新秀 - 车辆图案
        // 车身
        final carBody = RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: 60 * scale, height: 30 * scale),
          Radius.circular(6 * scale),
        );
        canvas.drawRRect(carBody, whitePaint);
        
        // 车轮
        canvas.drawCircle(
          Offset(center.dx - 18 * scale, center.dy + 15 * scale),
          8 * scale,
          whitePaint,
        );
        canvas.drawCircle(
          Offset(center.dx + 18 * scale, center.dy + 15 * scale),
          8 * scale,
          whitePaint,
        );
        break;

      case 3: // 活跃达人 - 五角星
        _drawStar(canvas, center, 40 * scale, whitePaint);
        break;

      case 4: // 进藏英雄 - 山峰图案
        final mountainPath = Path();
        mountainPath.moveTo(center.dx - 50 * scale, center.dy + 20 * scale);
        mountainPath.lineTo(center.dx - 20 * scale, center.dy - 30 * scale);
        mountainPath.lineTo(center.dx, center.dy - 10 * scale);
        mountainPath.lineTo(center.dx + 25 * scale, center.dy - 40 * scale);
        mountainPath.lineTo(center.dx + 50 * scale, center.dy + 20 * scale);
        mountainPath.close();
        canvas.drawPath(mountainPath, whitePaint);
        
        // 太阳
        canvas.drawCircle(
          Offset(center.dx + 20 * scale, center.dy - 30 * scale),
          12 * scale,
          Paint()..color = Colors.white.withOpacity(0.6),
        );
        break;

      case 5: // 阿拉善之星 - 沙漠/骆驼图案
        // 沙丘
        final dunePathPath = Path();
        dunePathPath.moveTo(center.dx - 50 * scale, center.dy + 20 * scale);
        dunePathPath.quadraticBezierTo(
          center.dx - 25 * scale,
          center.dy - 20 * scale,
          center.dx,
          center.dy + 10 * scale,
        );
        dunePathPath.quadraticBezierTo(
          center.dx + 25 * scale,
          center.dy - 30 * scale,
          center.dx + 50 * scale,
          center.dy + 20 * scale,
        );
        canvas.drawPath(
          dunePathPath,
          Paint()
            ..color = Colors.white.withOpacity(0.9)
            ..style = PaintingStyle.fill,
        );
        
        // 星星
        _drawStar(canvas, Offset(center.dx, center.dy - 25 * scale), 15 * scale, whitePaint);
        break;

      case 6: // 金牌改装 - 扳手图案
        // 扳手
        final wrenchPath = Path();
        wrenchPath.moveTo(center.dx - 25 * scale, center.dy - 30 * scale);
        wrenchPath.lineTo(center.dx - 15 * scale, center.dy - 30 * scale);
        wrenchPath.lineTo(center.dx - 15 * scale, center.dy + 10 * scale);
        wrenchPath.lineTo(center.dx - 5 * scale, center.dy + 10 * scale);
        wrenchPath.lineTo(center.dx - 5 * scale, center.dy + 20 * scale);
        wrenchPath.lineTo(center.dx + 5 * scale, center.dy + 20 * scale);
        wrenchPath.lineTo(center.dx + 5 * scale, center.dy + 10 * scale);
        wrenchPath.lineTo(center.dx + 15 * scale, center.dy + 10 * scale);
        wrenchPath.lineTo(center.dx + 15 * scale, center.dy - 30 * scale);
        wrenchPath.lineTo(center.dx + 25 * scale, center.dy - 30 * scale);
        wrenchPath.lineTo(center.dx + 25 * scale, center.dy - 40 * scale);
        wrenchPath.lineTo(center.dx - 25 * scale, center.dy - 40 * scale);
        wrenchPath.close();
        canvas.drawPath(wrenchPath, whitePaint);
        break;

      default: // 未解锁
        canvas.drawCircle(
          center,
          30 * scale,
          Paint()..color = Colors.white.withOpacity(0.4),
        );
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    final outerRadius = radius;
    final innerRadius = radius * 0.4;

    for (int i = 0; i < 10; i++) {
      final angle = (i * math.pi / 5) - math.pi / 2;
      final r = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawLevelMarker(Canvas canvas, Offset center, double scale) {
    // 等级标记背景
    final markerRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + 35 * scale, center.dy + 45 * scale),
        width: 30 * scale,
        height: 30 * scale,
      ),
      Radius.circular(4 * scale),
    );

    canvas.drawRRect(
      markerRect,
      Paint()..color = const Color(0xFF8B6B4F).withOpacity(0.3),
    );

    // 等级数字
    final textPainter = TextPainter(
      text: TextSpan(
        text: id <= 3 ? '1' : '?',
        style: TextStyle(
          color: const Color(0xFFE5C07B),
          fontSize: 20 * scale,
          fontWeight: FontWeight.bold,
          fontFamily: 'Oswald',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx + 35 * scale - textPainter.width / 2,
        center.dy + 45 * scale - textPainter.height / 2,
      ),
    );
  }

  void _drawGloss(Canvas canvas, Offset center, double scale) {
    // 光泽效果
    final glossPath = Path();
    glossPath.moveTo(center.dx - 70 * scale, center.dy - 20 * scale);
    glossPath.quadraticBezierTo(
      center.dx,
      center.dy - 80 * scale,
      center.dx + 70 * scale,
      center.dy - 20 * scale,
    );

    canvas.drawPath(
      glossPath,
      Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * scale,
    );
  }

  List<Offset> _getPentagonPoints(Offset center, double radius, double startAngle) {
    final points = <Offset>[];
    for (int i = 0; i < 5; i++) {
      final angle = startAngle + (i * 2 * math.pi / 5);
      points.add(Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      ));
    }
    return points;
  }

  @override
  bool shouldRepaint(MedalPainter oldDelegate) {
    return oldDelegate.id != id || oldDelegate.grayscale != grayscale;
  }
}
