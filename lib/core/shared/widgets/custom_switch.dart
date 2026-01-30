import 'package:flutter/material.dart';

/// 自定义开关控件 - 像素级还原原型设计
/// 
/// 设计规范：
/// - 开启状态：黑色背景 (#111111)，白色圆形滑块
/// - 关闭状态：浅灰色背景 (#E5E5E5)，白色圆形滑块
/// - 尺寸：宽度 48px，高度 28px
/// - 滑块直径：20px
/// - 动画时长：300ms
/// - 圆角：完全圆角 (borderRadius = height / 2)
class CustomSwitch extends StatefulWidget {
  /// 开关状态
  final bool value;
  
  /// 状态改变回调
  final ValueChanged<bool>? onChanged;
  
  /// 开启状态颜色
  final Color activeColor;
  
  /// 关闭状态颜色
  final Color inactiveColor;
  
  /// 滑块颜色
  final Color thumbColor;
  
  /// 开关宽度
  final double width;
  
  /// 开关高度
  final double height;
  
  /// 滑块直径
  final double thumbSize;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = const Color(0xFF111111),
    this.inactiveColor = const Color(0xFFE5E5E5),
    this.thumbColor = Colors.white,
    this.width = 48.0,
    this.height = 28.0,
    this.thumbSize = 20.0,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.value) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onChanged != null) {
      widget.onChanged!(!widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onChanged != null ? _handleTap : null,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // 计算滑块位置 - 左右各留4px padding
          final thumbOffset = _animation.value * (widget.width - widget.thumbSize - 8);
          
          // 计算背景颜色
          final backgroundColor = Color.lerp(
            widget.inactiveColor,
            widget.activeColor,
            _animation.value,
          );

          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
            child: Stack(
              children: [
                // 滑块
                Positioned(
                  left: 4 + thumbOffset,
                  top: (widget.height - widget.thumbSize) / 2,
                  child: Container(
                    width: widget.thumbSize,
                    height: widget.thumbSize,
                    decoration: BoxDecoration(
                      color: widget.thumbColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
