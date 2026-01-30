import 'package:flutter/material.dart';

class TireTrackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    
    // 使用 saveLayer 实现 Alpha 通道屏蔽，这是还原 SVG mask 的最精准方式
    final Paint layerPaint = Paint();
    canvas.saveLayer(rect, layerPaint);

    // 略微提高色深，由 0.035 调整至 0.055，以增强视觉存在感
    final trackPaint = Paint()
      ..color = Colors.black.withOpacity(0.055) 
      ..style = PaintingStyle.fill;

    canvas.save();
    // 匹配原型：transform="translate(160, -50) rotate(15) scale(1.6)"
    canvas.translate(160, -50);
    canvas.rotate(15 * 3.1415927 / 180);
    canvas.scale(1.6);

    void drawTrack(double y) {
      final pathLeft = Path()
        ..moveTo(0, y)
        ..lineTo(40, y)
        ..lineTo(50, y + 20)
        ..lineTo(30, y + 20)
        ..close();
      canvas.drawPath(pathLeft, trackPaint);

      final pathRight = Path()
        ..moveTo(60, y)
        ..lineTo(100, y)
        ..lineTo(90, y + 20)
        ..lineTo(70, y + 20)
        ..close();
      canvas.drawPath(pathRight, trackPaint);
    }

    for (double y = 0; y <= 180; y += 30) {
      drawTrack(y);
    }

    // 同步略微提高辅助线条色深
    final linePaint = Paint()
      ..color = Colors.black.withOpacity(0.025) 
      ..style = PaintingStyle.fill;
    canvas.drawRect(const Rect.fromLTWH(45, 0, 10, 220), linePaint);

    canvas.restore();

    // 应用 DstIn 混合模式进行 Alpha 蒙版处理
    const Gradient maskGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.transparent, 
        Colors.transparent,
        Colors.black,      
      ],
      stops: [0.0, 0.4, 1.0],
    );

    final Paint maskPaint = Paint()
      ..blendMode = BlendMode.dstIn
      ..shader = maskGradient.createShader(rect);
    
    canvas.drawRect(rect, maskPaint);
    
    canvas.restore(); 
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TireTrackBackground extends StatelessWidget {
  const TireTrackBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: TireTrackPainter(),
        ),
      ),
    );
  }
}
