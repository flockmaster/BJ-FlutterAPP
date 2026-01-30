import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../core/components/baic_ui_kit.dart';
import '../../common/ui_converters.dart';
import 'update_nickname_viewmodel.dart';

class UpdateNicknameView extends StatelessWidget {
  const UpdateNicknameView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateNicknameViewModel>.reactive(
      viewModelBuilder: () => UpdateNicknameViewModel(),
      builder: (context, viewModel, child) => _buildView(context, viewModel),
    );
  }

  Widget _buildView(BuildContext context, UpdateNicknameViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A1A)),
          onPressed: viewModel.goBack,
        ),
        centerTitle: true,
        title: Text(viewModel.pageTitle, style: const TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          BaicBounceButton(
            onPressed: viewModel.isValid && !viewModel.isLoading ? viewModel.saveNickname : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              alignment: Alignment.center,
              child: viewModel.isLoading.visible(
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5, 
                    color: Color(0xFFEB4628),
                  ),
                ),
              ).orElse(
                Text(
                  viewModel.saveButtonText,
                  style: TextStyle(
                    color: viewModel.isValid ? const Color(0xFFEB4628) : Colors.black26,
                    fontSize: 16,
                    fontWeight: FontWeight.w900, // 增加粗细，更有设计师感
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8), // 增加右侧间距
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Avatar
            Center(
              child: GestureDetector(
                onTap: viewModel.changeAvatar,
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF8F70), Color(0xFFEB4628)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bolt, color: Colors.white, size: 40),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Nickname Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(viewModel.nicknameLabel, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                TextField(
                  onChanged: viewModel.updateNickname,
                  style: const TextStyle(fontSize: 18, color: Color(0xFF1A1A1A)),
                  decoration: InputDecoration(
                    hintText: viewModel.hintText,
                    hintStyle: const TextStyle(color: Color(0xFFCCCCCC)),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFEEEEEE))),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFEB4628))),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: viewModel.importFromWechat,
                  child: Row(
                    children: [
                      const Icon(Icons.message, color: Color(0xFF00C250), size: 18),
                      const SizedBox(width: 4),
                      Text(viewModel.wechatImportText, style: const TextStyle(color: Color(0xFF00C250), fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Text(
              viewModel.disclaimerText,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}