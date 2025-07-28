# Android应用签名配置指南

目前的GitHub Actions配置使用debug签名来构建APK，这适用于测试和开发。对于生产发布，你需要配置release签名。

## 生产签名配置（可选）

### 1. 创建签名密钥

```bash
# 在neverr_app/android目录下执行
keytool -genkey -v -keystore ~/neverr-release-key.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias neverr
```

### 2. 配置key.properties

在 `neverr_app/android/` 目录下创建 `key.properties` 文件：
```properties
storePassword=你的密钥库密码
keyPassword=你的密钥密码
keyAlias=neverr
storeFile=../neverr-release-key.keystore
```

### 3. 修改build.gradle.kts

在 `neverr_app/android/app/build.gradle.kts` 中添加：

```kotlin
// 在文件顶部添加
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... 其他配置

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            // 移除或注释掉debug签名
            // signingConfig = signingConfigs.getByName("debug")
        }
    }
}
```

### 4. GitHub Secrets配置（用于CI/CD）

如果要在GitHub Actions中使用release签名：

1. 将签名文件base64编码：
```bash
base64 neverr-release-key.keystore > keystore.txt
```

2. 在GitHub仓库设置中添加Secrets：
- `KEYSTORE_BASE64`: 编码后的签名文件内容
- `KEYSTORE_PASSWORD`: 密钥库密码
- `KEY_PASSWORD`: 密钥密码
- `KEY_ALIAS`: 密钥别名

### 5. 更新GitHub Actions工作流

如果配置了签名，可以在 `.github/workflows/release.yml` 中添加：

```yaml
- name: Setup signing
  run: |
    echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > neverr_app/android/neverr-release-key.keystore
    echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" >> neverr_app/android/key.properties
    echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> neverr_app/android/key.properties
    echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> neverr_app/android/key.properties
    echo "storeFile=../neverr-release-key.keystore" >> neverr_app/android/key.properties
```

## 注意事项

1. **保密性**: 永远不要将签名密钥和密码提交到版本控制系统
2. **备份**: 请妥善保管签名密钥，丢失后无法更新应用
3. **测试**: 目前的debug签名足够用于测试和开发
4. **Google Play**: 发布到Google Play商店时必须使用release签名

## 当前状态

目前的配置使用debug签名，这意味着：
- ✅ 可以正常安装和测试
- ✅ 适合开发和内部分发
- ❌ 不适合发布到应用商店
- ❌ 每次clean build后签名可能变化

如果只是内部测试使用，当前配置已经足够。 