# XDSDK Binary SPM

通过 Swift Package Manager 分发的 XDSDK iOS SDK。

## 环境要求

- `XDSDKCN`、`XDSDKDouYinGame` 最低支持 iOS 13.0+
- `XDSDKGlobal`、`XDSDKGlobalCrashlytics` 最低支持 iOS 15.0+
- 仅支持真机，不支持 Simulator

## 添加依赖

### 1. 添加 Git 仓库

在 Xcode 中选择 `File → Add Package Dependencies...`，输入 XDSDK SPM 仓库地址：

```text
https://github.com/xindong/XDSDK-SPM.git
```

如果在无法正常访问 GitHub 环境的网络下使用，可切换成 GitCode 地址：

```text
https://gitcode.com/XDSDK/XDSDK-SPM.git
```

Dependency Rule 建议按发布阶段选择：

- 正式版本：选择 `Up to Next Major Version`，填入当前正式版本号，例如 `7.3.1`
- RC / beta 验证：选择 `Exact Version`，填入完整版本号，例如 `7.3.1-rc.1`

### 2. 选择 Product

在 `Add Package` 的产品选择页面，按场景选择 Product 加到 App target；主 Product 均包含支付能力。

| 场景 | Product |
| --- | --- |
| 中国大陆 | `XDSDKCN` |
| 海外 | `XDSDKGlobal` |
| 海外 + Firebase Crashlytics | `XDSDKGlobalCrashlytics` |
| 抖音小游戏附加能力（可选） | `XDSDKDouYinGame` |

`XDSDKCN`、`XDSDKGlobal`、`XDSDKGlobalCrashlytics` 三者通常只选一个。`XDSDKDouYinGame` 是可选外挂能力，只在需要时额外添加。

## 配置 App Target

添加 Product 后，还需要在 App target 添加两个 Run Script Build Phase：拷贝资源、自动配置 `Info.plist`。

> 两个脚本都直接调用 SPM checkout 路径下的版本，**请勿**复制到自己工程，这样升级 SPM 时脚本会同步更新。

### 1. 拷贝资源

在 App target → `Build Phases` 添加 Run Script Phase，命名为 `Copy XDSDK Resources`，填入：

```bash
SCRIPT_PATH="${BUILD_DIR%/Build/*}/SourcePackages/checkouts/XDSDK-SPM/Scripts/copy_xdsdk_resources.sh"
if [[ -f "$SCRIPT_PATH" ]]; then
    bash "$SCRIPT_PATH"
else
    echo "warning: XDSDK SPM resource script not found at $SCRIPT_PATH"
fi
```

脚本会读取 `XDConfig.json` 的 `region_type`：CN 复制通用 `TapSDK4` + `CN` 资源，Global 复制通用 `TapSDK4` + `Oversea` 资源，不再把另一地区资源一起打进 `.app`。

要求：

- 把这个 phase 拖到 Build Phases 的最后（`Embed Frameworks` / `[CP] Embed Pods Frameworks` 之后）
- 取消勾选 `Based on dependency analysis`
- `Build Settings` 中把 `User Script Sandboxing`（`ENABLE_USER_SCRIPT_SANDBOXING`）设为 `NO`
- 默认在 `${SRCROOT}/${PRODUCT_NAME}/XDConfig.json` 查找配置；如不在该路径，需要在这个 Run Script 内设置 `XDSDK_CONFIG_PATH=/绝对/路径/XDConfig.json`

### 2. 自动配置 `Info.plist`

读取 App 工程下的 `XDConfig.json`，根据 `region_type` 按需写入当前区域的 `CFBundleURLTypes` / `LSApplicationQueriesSchemes`，并为 Global 配置写入 Facebook 必需的顶层键，免去手动维护。通用 XDSDK / TapTap 参数始终按配置内容生成；CN 只生成微信、QQ、微博、小红书、抖音、快手等国内平台参数，Global 只生成 Facebook、Line、Twitter、Google、TikTok 等海外平台参数。

再添加一个 Run Script Phase，命名为 `Configure XDSDK Info.plist`，填入：

```bash
SCRIPT_PATH="${BUILD_DIR%/Build/*}/SourcePackages/checkouts/XDSDK-SPM/Scripts/configure_xdsdk_info_plist.py"
if [[ -f "$SCRIPT_PATH" ]]; then
    /usr/bin/env python3 "$SCRIPT_PATH"
else
    echo "warning: XDSDK SPM info-plist script not found at $SCRIPT_PATH"
fi
```

要求：

- 这个 phase 必须排在 `Compile Sources` **之前**
- 取消勾选 `Based on dependency analysis`
- `User Script Sandboxing` 同样设为 `NO`
- 默认在 `${SRCROOT}/${PRODUCT_NAME}/XDConfig.json` 查找配置；如不在该路径，可在 Run Script 环境里设置 `XDSDK_CONFIG_PATH=/绝对/路径/XDConfig.json`

如果一个 App 显式携带多份 CN / Global 配置，需要在两个 Run Script Phase 中设置相同的 `XDSDK_EXTRA_CONFIG_PATHS`，值为冒号分隔的额外配置路径；两个脚本会分别合并这些配置需要的 plist 参数和区域资源。Facebook 顶层键会从全部 Global 配置中合并；如果不同配置提供了冲突的 `FacebookAppID` 或 `FacebookClientToken`，构建会直接失败，避免静默使用错误配置。

### 3. 验证

`Product → Clean Build Folder` 后再 Build，构建日志中应能看到 `Copied <BundleName>.bundle` 的输出；产物 `.app`（右键 Show Package Contents）根目录应包含对应的 `.bundle`。

### 可选：Firebase Crashlytics 符号上传

如果使用 `XDSDKGlobalCrashlytics`，添加 Run Script Phase，命名为 `Upload Crashlytics Symbols`：

```bash
SCRIPT_PATH="${BUILD_DIR%/Build/*}/SourcePackages/checkouts/XDSDK-SPM/Scripts/FirebaseCrashlytics/run"
if [[ -f "$SCRIPT_PATH" ]]; then
    "$SCRIPT_PATH"
else
    echo "warning: Firebase Crashlytics script not found at $SCRIPT_PATH"
fi
```

要求：

- 此 Phase 必须放在 `Embed Frameworks` / `[CP] Embed Pods Frameworks` **之后**（脚本依赖链接产生的 dSYM）
- 取消勾选 `Based on dependency analysis`
- `User Script Sandboxing` 设为 `NO`
- 在脚本的 **Input Files** 中添加 `$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)` 和 `$(DWARF_DSYM_FOLDER_PATH)/$(DWARF_DSYM_FILE_NAME)`，确保 dSYM 能被正确读取

## 注意事项

- 多 target（App + App Clip + Extension 等）：每个需要资源 / scheme 的 target 都要单独添加上述两个 Run Script Phase
- CI / Xcode Cloud 同样需要上述 sandbox 设置
- 带 `xdsdk.` 前缀的 `CFBundleURLName` 条目由脚本管理，每次构建会被覆盖，要改请改 `XDConfig.json`
- 当前仓库采用二进制分发，`.xcframework.zip` 会从 `Package.swift` 中声明的 URL 下载
