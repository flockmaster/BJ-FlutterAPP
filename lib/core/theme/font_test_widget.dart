import 'package:flutter/material.dart';
import 'app_typography.dart';

/// 字体测试组件
/// 用于验证 Oswald 字体是否正确加载
class FontTestWidget extends StatelessWidget {
  const FontTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('字体测试'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('数据展示字体 (Oswald)', [
              _buildTextSample('XL - 32px', '1234567890', AppTypography.dataDisplayXL),
              _buildTextSample('L - 28px', '1234567890', AppTypography.dataDisplayL),
              _buildTextSample('M - 20px', '1234567890', AppTypography.dataDisplayM),
              _buildTextSample('S - 16px', '1234567890', AppTypography.dataDisplayS),
              _buildTextSample('XS - 14px', '1234567890', AppTypography.dataDisplayXS),
            ]),
            const SizedBox(height: 32),
            _buildSection('价格样式 (Oswald)', [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('¥', style: AppTypography.priceCurrency),
                  Text('1299', style: AppTypography.priceMain),
                ],
              ),
              const SizedBox(height: 8),
              Text('¥199', style: AppTypography.priceSmall),
              const SizedBox(height: 8),
              Text('¥299', style: AppTypography.priceOriginal),
            ]),
            const SizedBox(height: 32),
            _buildSection('系统默认字体', [
              _buildTextSample('标题 L', '这是大标题', AppTypography.headingL),
              _buildTextSample('标题 M', '这是中标题', AppTypography.headingM),
              _buildTextSample('标题 S', '这是小标题', AppTypography.headingS),
              _buildTextSample('正文主要', '这是主要正文内容', AppTypography.bodyPrimary),
              _buildTextSample('正文次要', '这是次要正文内容', AppTypography.bodySecondary),
              _buildTextSample('说明文字', '这是说明文字', AppTypography.captionPrimary),
            ]),
            const SizedBox(height: 32),
            _buildSection('混合使用示例', [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('商品名称', style: AppTypography.headingM),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('¥', style: AppTypography.priceCurrency),
                        Text('1299', style: AppTypography.priceMain),
                        const SizedBox(width: 8),
                        Text('¥1599', style: AppTypography.priceOriginal),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('已售 2,300+ 件', style: AppTypography.captionSecondary),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildTextSample(String label, String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(text, style: style),
        ],
      ),
    );
  }
}
