# 🦞 小龙虾App - 快速开始指南

## 一、安装必要的软件

### 1. 安装Java JDK
```bash
brew install openjdk@17
```

### 2. 配置Java环境变量
```bash
echo 'export JAVA_HOME=/opt/homebrew/opt/openjdk@17' >> ~/.zshrc
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.zshrc
source ~/.zshrc
```

验证安装：
```bash
java -version
```

### 3. 安装Android SDK
有两种方式：

**方式A：安装Android Studio（推荐）**
- 下载：https://developer.android.com/studio
- 安装后运行，接受许可，安装SDK Platform-Tools

**方式B：仅安装命令行工具**
```bash
brew install --cask android-studio
```

### 4. 配置Android SDK环境变量
```bash
echo 'export ANDROID_HOME=$HOME/Library/Android/sdk' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.zshrc
source ~/.zshrc
```

## 二、构建APK

### 方法1：使用自动脚本
```bash
cd /Users/adrianchen/WorkBuddy/20260310235638/crayfish_app
chmod +x setup.sh
./setup.sh
```

### 方法2：手动构建
```bash
cd /Users/adrianchen/WorkBuddy/20260310235638/crayfish_app
chmod +x gradlew
./gradlew assembleDebug
```

成功后，APK位于：`app/build/outputs/apk/debug/app-debug.apk`

## 三、安装到手机

### 1. 启用手机的开发者选项和USB调试
- 进入 设置 > 关于手机
- 连续点击"版本号"7次
- 返回设置，找到"开发者选项"
- 启用"USB调试"

### 2. 连接手机
用USB数据线连接手机到电脑，然后在手机上授权USB调试

### 3. 验证连接
```bash
adb devices
```
应该看到你的设备列表

### 4. 安装APK
```bash
adb install app/build/outputs/apk/debug/app-debug.apk
```

### 5. 打开应用
在手机上找到"小龙虾"图标，点击打开即可看到可爱的小龙虾！

## 四、常见问题

### 问题1：找不到Java
**解决**：安装并配置Java（见步骤1和2）

### 问题2：找不到Android SDK
**解决**：安装Android Studio或Android SDK命令行工具

### 问题3：adb命令不存在
**解决**：确保已配置ANDROID_HOME环境变量，并安装了Android Platform-Tools

### 问题4：构建时提示"SDK location not found"
**解决**：
- 在`local.properties`文件中添加：`sdk.dir=/Users/adrianchen/Library/Android/sdk`
- 或者运行：`echo "sdk.dir=$ANDROID_HOME" > local.properties`

### 问题5：Gradle下载很慢
**解决**：配置国内镜像源，在`gradle.properties`中添加：
```properties
maven.aliyun.com=https://maven.aliyun.com/repository/public
```

## 五、项目说明

这是一个简单的Android应用，具有以下特点：

- 🦞 可爱的小龙虾图标（自定义SVG矢量图）
- 📱 简洁的单一页面界面
- 🎨 红色主题设计
- ✨ 支持Android 7.0及以上版本
- 📦 生成可安装的APK文件

## 六、修改应用

### 修改图标
编辑 `app/src/main/res/drawable/crayfish.xml` 文件

### 修改应用名称
编辑 `app/src/main/res/values/strings.xml` 文件

### 修改界面布局
编辑 `app/src/main/res/layout/activity_main.xml` 文件

### 修改应用逻辑
编辑 `app/src/main/java/com/crayfish/app/MainActivity.java` 文件

## 需要帮助？

如果遇到问题，请检查：
1. Java和Android SDK是否正确安装
2. 环境变量是否配置正确
3. 构建日志中的错误信息

祝使用愉快！🎉
