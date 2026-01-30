#!/bin/bash

# 原型同步脚本 - 自动从 GitHub 拉取最新的 AI Studio 原型
# 仓库地址: https://github.com/flockmaster/-APP-
# 目标目录: prototypes/

set -e

REPO_URL="https://github.com/flockmaster/-APP-.git"
TARGET_DIR="/Users/tingjing/BJ-FlutterAPP/prototypes"
TEMP_DIR="/Users/tingjing/BJ-FlutterAPP/prototypes_temp"

echo "🚀 开始同步最新的产品原型..."

# 1. 清理临时目录
if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

# 2. 克隆最新代码到临时目录
echo "📥 正在从 GitHub 克隆代码..."
git clone --depth 1 $REPO_URL $TEMP_DIR

# 3. 确保目标目录存在
mkdir -p $TARGET_DIR

# 4. 同步文件 (排除 .git 目录)
echo "📂 正在同步到 prototypes 目录..."
cp -rf $TEMP_DIR/* $TARGET_DIR/
# 处理隐藏文件 (如 .gitignore, .env 等，但不包括 .git)
cp -p $TEMP_DIR/.[!.]* $TARGET_DIR/ 2>/dev/null || true

# 5. 清理临时目录
rm -rf $TEMP_DIR

echo "✅ 原型同步完成！"
echo "📍 目录位置: $TARGET_DIR"
echo "⏰ 同步时间: $(date '+%Y-%m-%d %H:%M:%S')"
