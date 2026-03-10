#!/bin/bash

echo "🚀 准备推送项目到GitHub..."

# 检查是否已配置GitHub Token
if [ -z "$GITHUB_TOKEN" ]; then
    echo ""
    echo "⚠️  请先设置GitHub Token："
    echo "   1. 访问 https://github.com/settings/tokens"
    echo "   2. 创建新的Token（选择repo权限）"
    echo "   3. 运行: export GITHUB_TOKEN=你的token"
    echo ""
    exit 1
fi

# 初始化Git仓库
echo "📦 初始化Git仓库..."
git init

# 添加所有文件
echo "➕ 添加文件..."
git add .

# 提交
echo "💾 提交代码..."
git commit -m "Initial commit: 小龙虾Android App"

# 询问仓库名称
read -p "请输入你的GitHub用户名: " USERNAME
read -p "请输入仓库名称 (建议: crayfish-app): " REPO_NAME

REPO_NAME=${REPO_NAME:-crayfish-app}

# 创建远程仓库并推送
echo "📤 推送到GitHub..."
git remote add origin https://$GITHUB_TOKEN@github.com/$USERNAME/$REPO_NAME.git

# 尝试推送
if git push -u origin master 2>/dev/null; then
    BRANCH="master"
elif git push -u origin main 2>/dev/null; then
    BRANCH="main"
else
    echo "❌ 推送失败，请检查你的GitHub Token和仓库名称"
    exit 1
fi

echo ""
echo "✅ 成功推送到GitHub！"
echo ""
echo "📊 查看构建进度："
echo "   https://github.com/$USERNAME/$REPO_NAME/actions"
echo ""
echo "📦 构建完成后，下载APK："
echo "   1. 访问上面的Actions页面"
echo "   2. 找到成功的构建工作流"
echo "   3. 点击 'Artifacts' 下载 APK"
echo ""
echo "🎉 然后就可以安装到手机上使用啦！"
