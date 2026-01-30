#!/bin/bash

# VR看车功能验证脚本
# 用于验证所有必要的文件和配置是否正确

echo "🔍 开始验证VR看车功能设置..."
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 计数器
PASS=0
FAIL=0
WARN=0

# 检查函数
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} 文件存在: $1"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗${NC} 文件缺失: $1"
        ((FAIL++))
        return 1
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} 目录存在: $1"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗${NC} 目录缺失: $1"
        ((FAIL++))
        return 1
    fi
}

check_content() {
    if grep -q "$2" "$1" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} 配置正确: $1 包含 '$2'"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗${NC} 配置错误: $1 不包含 '$2'"
        ((FAIL++))
        return 1
    fi
}

check_file_size() {
    if [ -f "$1" ]; then
        SIZE=$(du -h "$1" | cut -f1)
        if [ "$SIZE" != "0B" ]; then
            echo -e "${GREEN}✓${NC} 文件大小正常: $1 ($SIZE)"
            ((PASS++))
            return 0
        else
            echo -e "${RED}✗${NC} 文件大小异常: $1 (0B)"
            ((FAIL++))
            return 1
        fi
    else
        echo -e "${RED}✗${NC} 文件不存在: $1"
        ((FAIL++))
        return 1
    fi
}

echo "📁 检查目录结构..."
echo "-----------------------------------"
check_dir "lib/ui/views/vr_experience"
check_dir "assets/models"
echo ""

echo "📄 检查核心文件..."
echo "-----------------------------------"
check_file "lib/ui/views/vr_experience/vr_experience_view.dart"
check_file "lib/ui/views/vr_experience/vr_experience_viewmodel.dart"
check_file "lib/ui/views/vr_experience/README.md"
check_file "lib/ui/views/vr_experience/MIGRATION_SUMMARY.md"
check_file "lib/ui/views/vr_experience/COLOR_IMPLEMENTATION_GUIDE.md"
echo ""

echo "🎨 检查3D模型文件..."
echo "-----------------------------------"
check_file_size "assets/models/BJ40-V1.glb"
echo ""

echo "⚙️  检查配置文件..."
echo "-----------------------------------"
check_content "pubspec.yaml" "model_viewer_plus"
check_content "pubspec.yaml" "assets/models/"
echo ""

echo "🔗 检查集成代码..."
echo "-----------------------------------"
check_content "lib/shared/widgets/car_buying/single_car_scroll_view.dart" "VRExperienceView"
check_content "lib/shared/widgets/car_buying/single_car_scroll_view.dart" "vr_experience/vr_experience_view.dart"
echo ""

echo "📚 检查文档..."
echo "-----------------------------------"
check_file "VR_FEATURE_QUICKSTART.md"
echo ""

# 检查Flutter环境
echo "🔧 检查Flutter环境..."
echo "-----------------------------------"
if command -v flutter &> /dev/null; then
    echo -e "${GREEN}✓${NC} Flutter已安装"
    flutter --version | head -1
    ((PASS++))
else
    echo -e "${RED}✗${NC} Flutter未安装"
    ((FAIL++))
fi
echo ""

# 检查依赖
echo "📦 检查依赖安装..."
echo "-----------------------------------"
if [ -d ".dart_tool" ]; then
    echo -e "${GREEN}✓${NC} 依赖已安装 (.dart_tool存在)"
    ((PASS++))
else
    echo -e "${YELLOW}⚠${NC} 依赖可能未安装，请运行: flutter pub get"
    ((WARN++))
fi
echo ""

# 检查模型文件大小
echo "📊 模型文件分析..."
echo "-----------------------------------"
if [ -f "assets/models/BJ40-V1.glb" ]; then
    SIZE_MB=$(du -m "assets/models/BJ40-V1.glb" | cut -f1)
    echo "模型文件大小: ${SIZE_MB}MB"
    if [ "$SIZE_MB" -gt 50 ]; then
        echo -e "${YELLOW}⚠${NC} 警告: 模型文件较大 (${SIZE_MB}MB)，建议压缩到 <10MB"
        ((WARN++))
    else
        echo -e "${GREEN}✓${NC} 模型文件大小合理"
        ((PASS++))
    fi
fi
echo ""

# 总结
echo "=================================="
echo "📊 验证结果总结"
echo "=================================="
echo -e "${GREEN}通过: $PASS${NC}"
echo -e "${RED}失败: $FAIL${NC}"
echo -e "${YELLOW}警告: $WARN${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✅ 所有必要文件和配置都已就绪！${NC}"
    echo ""
    echo "🚀 下一步操作:"
    echo "   1. 运行: flutter pub get"
    echo "   2. 运行: flutter run"
    echo "   3. 测试VR看车功能"
    echo ""
    echo "📖 参考文档:"
    echo "   - VR_FEATURE_QUICKSTART.md"
    echo "   - lib/ui/views/vr_experience/README.md"
    exit 0
else
    echo -e "${RED}❌ 发现 $FAIL 个问题，请修复后重试${NC}"
    echo ""
    echo "💡 常见问题解决:"
    echo "   1. 文件缺失: 检查是否正确复制了所有文件"
    echo "   2. 配置错误: 检查pubspec.yaml配置"
    echo "   3. 模型文件: 确保BJ40-V1.glb已复制到assets/models/"
    exit 1
fi
