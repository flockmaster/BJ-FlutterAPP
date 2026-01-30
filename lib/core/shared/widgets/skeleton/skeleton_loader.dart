import 'package:flutter/material.dart';

/// 骨架屏加载器 - 像素级还原原型设计
class SkeletonLoader extends StatefulWidget {
  final Widget child;
  final bool enabled;
  
  const SkeletonLoader({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ExcludeSemantics(
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color(0xFFE5E7EB),
                  Color(0xFFF9FAFB),
                  Color(0xFFE5E7EB),
                ],
                stops: [
                  (_controller.value - 0.3).clamp(0.0, 1.0),
                  _controller.value.clamp(0.0, 1.0),
                  (_controller.value + 0.3).clamp(0.0, 1.0),
                ],
              ).createShader(bounds);
            },
            child: widget.child,
          ),
        );
      },
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: borderRadius ?? BorderRadius.circular(16),
      ),
    );
  }
}

class SkeletonCircle extends StatelessWidget {
  final double size;
  
  const SkeletonCircle({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFE5E7EB),
        shape: BoxShape.circle,
      ),
    );
  }
}

class SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;
  
  const SkeletonLine({
    super.key,
    this.width,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(6),
    );
  }
}
