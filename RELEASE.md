# 自动构建和发布指南

这个项目已经配置了GitHub Actions，可以在创建新的Release时自动构建Android APK文件。

## 如何创建Release并获得APK

### 步骤1: 更新版本号
在发布之前，请确保更新 `pubspec.yaml` 中的版本号：
```yaml
version: 1.0.1+2  # 格式: 版本号+构建号
```

### 步骤2: 创建GitHub Release
1. 进入GitHub仓库页面
2. 点击右侧的 "Releases"
3. 点击 "Create a new release"
4. 填写Tag version（例如：v1.0.1）
5. 填写Release title和描述
6. 点击 "Publish release"

### 步骤3: 等待构建完成
- GitHub Actions会自动开始构建
- 构建过程大约需要5-10分钟
- 可以在Actions页面查看构建进度

### 步骤4: 下载APK
构建完成后，在Release页面会看到：
- `app-release.apk` - 可直接安装的APK文件
- `app-release.aab` - Google Play商店发布文件

## 构建内容说明

- **APK文件**: 适用于直接安装到Android设备，支持侧载安装
- **AAB文件**: 适用于发布到Google Play商店，体积更小，支持动态交付

## 故障排除

如果构建失败，可能的原因：
1. 代码编译错误 - 检查本地是否能正常构建
2. 依赖问题 - 确保所有依赖都在pubspec.yaml中正确声明
3. 签名问题 - 目前使用debug签名，生产环境需要配置release签名

## 本地测试构建

在推送到GitHub之前，建议本地测试构建：
```bash
# 进入项目目录
cd neverr_app

# 清理之前的构建
flutter clean

# 获取依赖
flutter pub get

# 构建APK
flutter build apk --release

# 构建AAB
flutter build appbundle --release
```

构建成功的文件位置：
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab` 