#!/bin/bash

echo "🔧 配置Android开发环境..."

# 设置JAVA_HOME
if [ -d "/opt/homebrew/opt/openjdk@17" ]; then
    export JAVA_HOME=/opt/homebrew/opt/openjdk@17
    echo "✓ JAVA_HOME设置为: $JAVA_HOME"
else
    echo "⚠️  未找到OpenJDK 17，请先运行: brew install openjdk@17"
    exit 1
fi

# 设置ANDROID_HOME
if [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME=$HOME/Library/Android/sdk
    echo "✓ ANDROID_HOME设置为: $ANDROID_HOME"
else
    echo "⚠️  未找到Android SDK，请先安装Android Studio"
    exit 1
fi

# 更新PATH
export PATH=$PATH:$JAVA_HOME/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/build-tools/34.0.0

echo ""
echo "📱 构建小龙虾APK..."

# 给gradlew执行权限
chmod +x gradlew

# 构建debug APK
./gradlew assembleDebug

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 构建成功！"
    echo "📦 APK位置: app/build/outputs/apk/debug/app-debug.apk"
    echo ""
    echo "💡 安装到设备："
    echo "   adb install app/build/outputs/apk/debug/app-debug.apk"
else
    echo ""
    echo "❌ 构建失败，请检查错误信息"
    exit 1
fi
