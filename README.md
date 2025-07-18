# Neverr App

**Slogan**: Not just quitting. Becoming better.

## 🎯 项目简介

Neverr 是一款基于心理学原理的习惯改变应用，通过录制和重复播放用户自己的语音来帮助用户戒除坏习惯或培养好习惯。应用的核心理念是通过"自我语音明示"来重塑潜意识，从而实现行为改变。

## ✨ 核心功能

- **智能引导**: 3页 onboarding 介绍应用理念
- **目标创建**: 预设习惯分类或自定义输入
- **AI 语句生成**: 集成 DeepSeek API 智能生成个性化语句
- **语音录制**: 完整的录音和播放功能
- **习惯管理**: 直观的主页展示和管理界面
- **统计分析**: 连续打卡、完成率等数据展示
- **日历视图**: 可视化的打卡历史记录
- **通知提醒**: 可配置的每日提醒功能
- **主题设置**: 支持浅色/深色模式切换

## 🛠 技术栈

- **框架**: Flutter 3.7.2+
- **状态管理**: Provider
- **本地存储**: SQLite + SharedPreferences
- **音频处理**: flutter_sound
- **通知**: flutter_local_notifications
- **UI**: Material Design 3
- **API**: DeepSeek AI

## 📱 支持平台

- iOS 12.0+
- Android API 21+
- 未来计划支持 Web 和桌面端

## 🚀 快速开始

### 环境要求

- Flutter SDK 3.7.2+
- Dart SDK 3.0.0+
- Xcode 14+ (iOS 开发)
- Android Studio (Android 开发)

### 安装步骤

1. **克隆项目**
   ```bash
   git clone https://github.com/Lavande/neverr-app.git
   cd neverr-app
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **配置 API 密钥**
   
   在 `lib/core/services/deepseek_service.dart` 中配置你的 DeepSeek API 密钥：
   ```dart
   static const String _apiKey = 'YOUR_DEEPSEEK_API_KEY';
   ```

4. **运行应用**
   ```bash
   # iOS 模拟器
   flutter run
   
   # Android 模拟器
   flutter run
   
   # 指定设备
   flutter run -d <device_id>
   ```

## 📖 应用使用指南

### 首次使用

1. **引导页面**: 了解应用的核心理念和使用方法
2. **创建目标**: 选择要改变的习惯或输入自定义习惯
3. **生成语句**: 使用 AI 生成个性化的声明语句
4. **录制语音**: 用自己的声音录制语句（建议 5 秒以上）
5. **开始练习**: 每天播放录制的语音，进行打卡

### 核心理念

- **"我从来不..."** 而不是"我要戒除..."
- **自己的声音** 最能影响潜意识
- **重复练习** 是改变的关键
- **正面肯定** 比负面否定更有效

## 📁 项目结构

```
lib/
├── core/
│   ├── router/          # 路由管理
│   ├── services/        # 核心服务
│   └── theme/           # 主题配置
├── models/              # 数据模型
├── providers/           # 状态管理
├── screens/             # 页面组件
└── widgets/             # 通用组件
```

## 🔒 隐私与安全

- **本地存储**: 所有数据存储在设备本地
- **语音隐私**: 录音文件仅保存在本地
- **API 安全**: DeepSeek API 仅用于生成文本，不传输个人数据
- **权限最小化**: 仅请求必要的麦克风和通知权限

## 🤝 贡献指南

欢迎贡献代码！请遵循以下步骤：

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 📄 开源协议

本项目使用 MIT 协议 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📞 联系方式

- 项目链接: [https://github.com/Lavande/neverr-app](https://github.com/Lavande/neverr-app)
- 问题反馈: [GitHub Issues](https://github.com/Lavande/neverr-app/issues)

## 🙏 致谢

- 灵感来源于 xiyan.txt 中关于习惯改变的心理学研究
- 感谢 Flutter 团队提供优秀的开发框架
- 感谢 DeepSeek AI 提供智能文本生成服务

---

**Neverr** - 不只是戒除，而是变得更好 ✨