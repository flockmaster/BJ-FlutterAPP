import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:car_owner_app/core/theme/app_colors.dart';
import 'package:car_owner_app/core/theme/app_styles.dart';
import 'package:car_owner_app/core/components/baic_ui_kit.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'login_viewmodel.dart';

/// [LoginView] - 应用登录页容器
/// 
/// 核心特性：
/// 1. 沉浸式星空背景：仅在主登录页启用，营造科技感品牌调性。
/// 2. 动效切换控制：采用 [AnimatedSwitcher] 实现主视图与表单录入视图的平滑位移与淡入转换。
/// 3. 系统 UI 适配：随背景亮暗动态调整状态栏文字颜色。
class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    // 根据模式决定状态栏文字颜色
    final bool isDarkBackground = viewModel.viewMode == 'main';
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkBackground ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: isDarkBackground ? Colors.black : Colors.white,
        body: Stack(
          children: [
            // 1. 只有主页面时才显示星空背景 (避免表单页漏光)
            if (isDarkBackground) _buildBackground(),
  
            // 2. 核心内容切换
            _buildAnimatedContent(viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedContent(LoginViewModel viewModel) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeInOutQuart,
      switchOutCurve: Curves.easeInOutQuart,
      transitionBuilder: (Widget child, Animation<double> animation) {
        // 使用滑入效果更符合全屏页面的直觉
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(animation);
        
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      },
      child: _buildBody(viewModel),
    );
  }

  Widget _buildBody(LoginViewModel viewModel) {
    switch (viewModel.viewMode) {
      case 'form':
        return const _FormView(key: ValueKey('form'));
      case 'wechat-bind':
        return const _WechatBindView(key: ValueKey('wechat-bind'));
      case 'forgot-pass':
        return const _ForgotPassView(key: ValueKey('forgot-pass'));
      default:
        return const _MainView(key: ValueKey('main'));
    }
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            'https://p.sda1.dev/21/5391ed2f0d4da231804f8e65306660e1/login_bg_stars.jpg', // 使用更纯净的星空
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: const Color(0xFF0A0F1E)),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black26,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const CircularProgressIndicator(
            color: AppColors.brandOrange,
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}

/// 首页视图：提供“本机号码一键登录”核心入口及微信快捷登录
class _MainView extends ViewModelWidget<LoginViewModel> {
  const _MainView({super.key});

  @override
  Widget build(BuildContext context, LoginViewModel viewModel) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // 这里的背景是透明的，因为使用了 LoginView 全局的背景构建
      color: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              Text(
                '悦享越野\n探索无界',
                style: AppStyles.h1.copyWith(
                  color: Colors.white,
                  fontSize: 42,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(0, 4),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Text(
                  '北京汽车 · 官方车主服务平台',
                  style: AppStyles.body.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(flex: 3),
              BaicBounceButton(
                onPressed: viewModel.isBusy ? null : () => viewModel.login('one-click'),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.brandOrange, Color(0xFFFF8C00)],
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brandOrange.withOpacity(0.4),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: viewModel.isBusy
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.smartphone, color: Colors.white, size: 24),
                            SizedBox(width: 12),
                            Text(
                              '本机号码一键登录',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 18),
              BaicBounceButton(
                onPressed: () => viewModel.setViewMode('form'),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withOpacity(0.4)),
                      ),
                      child: const Center(
                        child: Text(
                          '其他手机号登录',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.white.withOpacity(0.15))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '更多快捷登录方式',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.white.withOpacity(0.15))),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: BaicBounceButton(
                  onPressed: viewModel.loginWithWechat,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF07C160),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF07C160).withOpacity(0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(LucideIcons.messageCircle, color: Colors.white, size: 28),
                  ),
                ),
              ),
              const Spacer(),
              _AgreementWidget(viewModel: viewModel),
            ],
          ),
        ),
      ),
    );
  }
}

/// 通用全屏内容包装器 (代契之前的 _LoginCard)
class _FullScreenContentWrapper extends StatelessWidget {
  final Widget child;
  final String title;
  final String? subtitle;
  final VoidCallback onBack;
  final Color backgroundColor;

  const _FullScreenContentWrapper({
    required this.child,
    required this.title,
    this.subtitle,
    required this.onBack,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor, // 彻底消除背景泄露
      child: Column(
        children: [
          // 顶部导航栏
          SafeArea(
            bottom: false,
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF111111), size: 28),
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 20, 32, 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111111),
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                  const SizedBox(height: 48),
                  child,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 底部勾选协议组件（支持基于同步 ID 的抖动特效）
class _AgreementWidget extends StatefulWidget {
  final LoginViewModel viewModel;
  const _AgreementWidget({required this.viewModel});

  @override
  State<_AgreementWidget> createState() => _AgreementWidgetState();
}

class _AgreementWidgetState extends State<_AgreementWidget> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  // 记录上一次的抖动ID
  int _lastShakeId = 0;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    // 针对协议抖动 ID 进行差值比对，若 ID 增加则触发本地动画控制器执行
    if (viewModel.shakeSyncId > _lastShakeId) {
      _lastShakeId = viewModel.shakeSyncId;
      _shakeController.forward(from: 0);
    }

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final double offset = (const [0, -6, 6, -3, 3, 0])[( _shakeController.value * 5).floor()] * (1 - _shakeController.value);
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaicBounceButton(
            onPressed: viewModel.toggleAgreed,
            child: Container(
              margin: const EdgeInsets.only(top: 2),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: viewModel.agreed ? AppColors.brandOrange : Colors.transparent,
                border: Border.all(
                  color: viewModel.isAgreementError 
                      ? Colors.red 
                      : (viewModel.agreed ? AppColors.brandOrange : Colors.white54),
                  width: viewModel.isAgreementError ? 2 : 1,
                ),
              ),
              child: viewModel.agreed
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              const TextSpan(
                text: '我已阅读并同意',
                children: [
                  TextSpan(
                    text: '《用户协议》',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '和'),
                  TextSpan(
                    text: '《隐私政策》',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '\n未注册手机号验证后将自动创建账号'),
                ],
              ),
              style: TextStyle(
                color: viewModel.isAgreementError ? Colors.red.shade300 : Colors.white54, 
                fontSize: 11, 
                height: 1.3
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 细化后的表单登录视图（支持验证码/密码双模式切换）
class _FormView extends ViewModelWidget<LoginViewModel> {
  const _FormView({super.key});

  @override
  Widget build(BuildContext context, LoginViewModel viewModel) {
    return _FullScreenContentWrapper(
      title: viewModel.loginMethod == 'sms' ? '验证码登录' : '密码登录',
      subtitle: '未注册手机号验证后自动创建账号',
      onBack: () => viewModel.setViewMode('main'),
      child: Column(
        children: [
          // 手机号输入
          _buildInput(
            prefix: const Text('+86 ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF111111))),
            placeholder: '请输入手机号',
            onChanged: (v) => viewModel.phone = v,
          ),
          const SizedBox(height: 32),
          // 验证码/密码输入
          if (viewModel.loginMethod == 'sms')
            _buildInput(
              placeholder: '请输入验证码',
              onChanged: (v) => viewModel.code = v,
              suffix: BaicBounceButton(
                onPressed: viewModel.countdown > 0 ? null : viewModel.sendCode,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: (viewModel.countdown > 0 ? Colors.grey : AppColors.brandOrange).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    viewModel.countdown > 0 ? '${viewModel.countdown}s' : '获取验证码',
                    style: TextStyle(
                      color: viewModel.countdown > 0 ? Colors.grey : AppColors.brandOrange,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            )
          else
            _buildInput(
              placeholder: '请输入密码',
              isPassword: !viewModel.showPassword,
              onChanged: (v) => viewModel.password = v,
              suffix: IconButton(
                onPressed: viewModel.toggleShowPassword,
                icon: Icon(
                  viewModel.showPassword ? LucideIcons.eyeOff : LucideIcons.eye,
                  color: const Color(0xFF6B7280),
                  size: 22,
                ),
              ),
            ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BaicBounceButton(
                onPressed: () => viewModel.setLoginMethod(
                  viewModel.loginMethod == 'sms' ? 'password' : 'sms',
                ),
                child: Text(
                  viewModel.loginMethod == 'sms' ? '账号密码登录' : '动态验证码登录',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF111111)),
                ),
              ),
              if (viewModel.loginMethod == 'password')
                BaicBounceButton(
                  onPressed: () => viewModel.setViewMode('forgot-pass'),
                  child: const Text('忘记密码?', style: TextStyle(color: Color(0xFF999999), fontSize: 13, fontWeight: FontWeight.w500)),
                ),
            ],
          ),
          const SizedBox(height: 56),
          BaicBounceButton(
            onPressed: viewModel.isBusy ? null : () => viewModel.login(viewModel.loginMethod),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: viewModel.isBusy
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text(
                        '立即登录',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const _AgreementWidgetLight(),
        ],
      ),
    );
  }

  Widget _buildInput({
    Widget? prefix,
    required String placeholder,
    Widget? suffix,
    bool isPassword = false,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (prefix != null) prefix,
          Expanded(
            child: TextField(
              obscureText: isPassword,
              onChanged: onChanged,
              keyboardType: isPassword ? TextInputType.text : TextInputType.phone,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                border: InputBorder.none,
              ),
            ),
          ),
          if (suffix != null) suffix,
        ],
      ),
    );
  }
}

/// 亮色模式协议组件
class _AgreementWidgetLight extends StatefulWidget {
  const _AgreementWidgetLight();

  @override
  State<_AgreementWidgetLight> createState() => _AgreementWidgetLightState();
}

class _AgreementWidgetLightState extends State<_AgreementWidgetLight> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  int _lastShakeId = 0;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      disposeViewModel: false,
      fireOnViewModelReadyOnce: true,
      onViewModelReady: (viewModel) {},
      builder: (context, viewModel, child) {
        // 监听抖动状态 (版本号检测)
        if (viewModel.shakeSyncId > _lastShakeId) {
          _lastShakeId = viewModel.shakeSyncId;
          _shakeController.forward(from: 0);
        }

        return AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            final double offset = (const [0, -6, 6, -3, 3, 0])[(_shakeController.value * 5).floor()] * (1 - _shakeController.value);
            return Transform.translate(
              offset: Offset(offset, 0),
              child: child,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaicBounceButton(
                onPressed: viewModel.toggleAgreed,
                child: Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: viewModel.agreed ? Colors.black : Colors.transparent,
                    border: Border.all(
                      color: viewModel.isAgreementError
                          ? Colors.red
                          : (viewModel.agreed ? Colors.black : Colors.grey.shade300),
                      width: viewModel.isAgreementError ? 2 : 1,
                    ),
                  ),
                  child: viewModel.agreed
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(
                  const TextSpan(
                    text: '我已阅读并同意',
                    children: [
                      TextSpan(
                        text: '《用户协议》',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '和'),
                      TextSpan(
                        text: '《隐私政策》',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '\n未注册手机号验证后将自动创建账号'),
                    ],
                  ),
                  style: TextStyle(
                    color: viewModel.isAgreementError ? Colors.red : Colors.grey,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 微信绑定视角
class _WechatBindView extends ViewModelWidget<LoginViewModel> {
  const _WechatBindView({super.key});

  @override
  Widget build(BuildContext context, LoginViewModel viewModel) {
    return _FullScreenContentWrapper(
      title: '账号绑定',
      subtitle: '为了您的账号安全，请绑定手机号',
      onBack: () => viewModel.setViewMode('main'),
      child: Column(
        children: [
          Center(
            child: Stack(
              children: [
                 Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF07C160).withOpacity(0.15), width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 42,
                    backgroundImage: NetworkImage(viewModel.wechatProfile?['avatar'] ?? ''),
                    backgroundColor: const Color(0xFFF3F4F6),
                  ),
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF07C160),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(LucideIcons.messageCircle, color: Colors.white, size: 14),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.wechatProfile?['name'] ?? '微信用户',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF111111)),
          ),
          const SizedBox(height: 56),
          _buildInput(
            prefix: const Text('+86 ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF111111))),
            placeholder: '请输入手机号',
            onChanged: (v) => viewModel.phone = v,
          ),
          const SizedBox(height: 32),
          _buildInput(
            placeholder: '请输入验证码',
            onChanged: (v) => viewModel.code = v,
            suffix: BaicBounceButton(
              onPressed: viewModel.countdown > 0 ? null : viewModel.sendCode,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.brandOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  viewModel.countdown > 0 ? '${viewModel.countdown}s' : '获取验证码',
                  style: const TextStyle(
                    color: AppColors.brandOrange,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 56),
          BaicBounceButton(
            onPressed: viewModel.isBusy ? null : viewModel.bindPhone,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF111111), Color(0xFF333333)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: viewModel.isBusy
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text(
                        '完成绑定',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    Widget? prefix,
    required String placeholder,
    Widget? suffix,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (prefix != null) prefix,
          Expanded(
            child: TextField(
              onChanged: onChanged,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                border: InputBorder.none,
              ),
            ),
          ),
          if (suffix != null) suffix,
        ],
      ),
    );
  }
}

/// 忘记密码视图 (Skeleton 实现)
class _ForgotPassView extends ViewModelWidget<LoginViewModel> {
  const _ForgotPassView({super.key});

  @override
  Widget build(BuildContext context, LoginViewModel viewModel) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => viewModel.setViewMode('form'),
            icon: const Icon(LucideIcons.arrowLeft, color: Colors.black),
          ),
          const SizedBox(height: 20),
          Text('重置密码', style: AppStyles.h1.copyWith(fontSize: 24)),
          const Text('验证手机号以设置新密码', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 40),
          const BaicSkeleton(width: double.infinity, height: 48),
          const SizedBox(height: 24),
          const BaicSkeleton(width: double.infinity, height: 48),
          const SizedBox(height: 24),
          const BaicSkeleton(width: double.infinity, height: 48),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: BaicBounceButton(
              onPressed: () {
                viewModel.setViewMode('form');
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.brandOrange,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Center(
                  child: Text(
                    '确认重置',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
