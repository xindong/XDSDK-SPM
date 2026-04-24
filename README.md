# XDSDK Binary SPM

XDSDK iOS SDK distributed through Swift Package Manager.

## Requirements

- iOS 11.0+ for `XDSDKCN` and `XDSDKDouYinGame`
- iOS 13.0+ for `XDSDKGlobal` and `XDSDKGlobalCrashlytics`
- Real device only. Simulator is not supported.

## Add the Dependency

### 1. Add the Git repository

In Xcode, choose `File → Add Package Dependencies...`, then enter the XDSDK SPM repository URL:

```text
https://github.com/xindong/XDSDK-SPM.git
```

If GitHub is not accessible from your network, use the GitCode URL instead:

```text
https://gitcode.com/XDSDK/XDSDK-SPM.git
```

Choose the dependency rule based on the release stage:

- Stable releases: use `Up to Next Major Version`, with the current stable version, for example `7.3.1`
- RC / beta validation: use `Exact Version`, with the full prerelease version, for example `7.3.1-rc.1`

### 2. Choose a Product

On the `Add Package` product selection page, add the Product you need to the App target. Main Products include payment support.

| Use case | Product |
| --- | --- |
| China mainland | `XDSDKCN` |
| Global | `XDSDKGlobal` |
| Global + Firebase Crashlytics | `XDSDKGlobalCrashlytics` |
| Douyin mini-game add-on (optional) | `XDSDKDouYinGame` |

Usually choose only one of `XDSDKCN`, `XDSDKGlobal`, and `XDSDKGlobalCrashlytics`. `XDSDKDouYinGame` is an optional add-on and should only be added when needed.

## Configure the App Target

After adding the Product, the App target needs two Run Script Build Phases: one to copy resources, one to auto-configure `Info.plist`.

> Both scripts are invoked directly from the SPM checkout. **Do not** copy them into your repo — this way they stay in sync when you upgrade the package.

### 1. Copy resources

In your App target → `Build Phases`, add a Run Script Phase named `Copy XDSDK Resources` with this body:

```bash
SCRIPT_PATH="${BUILD_DIR%/Build/*}/SourcePackages/checkouts/XDSDK-SPM/Scripts/copy_xdsdk_resources.sh"
if [[ -f "$SCRIPT_PATH" ]]; then
    bash "$SCRIPT_PATH"
else
    echo "warning: XDSDK SPM resource script not found at $SCRIPT_PATH"
fi
```

Requirements:

- Move this phase to the end of Build Phases (after `Embed Frameworks` / `[CP] Embed Pods Frameworks`)
- Uncheck `Based on dependency analysis`
- In `Build Settings`, set `User Script Sandboxing` (`ENABLE_USER_SCRIPT_SANDBOXING`) to `NO`

### 2. Auto-configure `Info.plist`

Reads `XDConfig.json` from the App project and writes `CFBundleURLTypes` / `LSApplicationQueriesSchemes` plus the top-level keys required by Facebook, so you don't have to maintain them by hand.

Add a second Run Script Phase named `Configure XDSDK Info.plist`:

```bash
SCRIPT_PATH="${BUILD_DIR%/Build/*}/SourcePackages/checkouts/XDSDK-SPM/Scripts/configure_xdsdk_info_plist.py"
if [[ -f "$SCRIPT_PATH" ]]; then
    /usr/bin/env python3 "$SCRIPT_PATH"
else
    echo "warning: XDSDK SPM info-plist script not found at $SCRIPT_PATH"
fi
```

Requirements:

- Place this phase **before** `Compile Sources`
- Uncheck `Based on dependency analysis`
- Set `User Script Sandboxing` to `NO`
- The script looks for the config at `${SRCROOT}/${PRODUCT_NAME}/XDConfig.json` by default. If it lives elsewhere, set `XDSDK_CONFIG_PATH=/absolute/path/XDConfig.json` in the Run Script env

### 3. Verify

`Product → Clean Build Folder`, then build. The build log should show `Copied <BundleName>.bundle` lines, and the produced `.app` (right-click → Show Package Contents) should contain the corresponding `.bundle` directories at its root.

### Optional: Firebase Crashlytics symbols

If you use `XDSDKGlobalCrashlytics`, add a Run Script Phase named `Upload Crashlytics Symbols`:

```bash
SCRIPT_PATH="${BUILD_DIR%/Build/*}/SourcePackages/checkouts/XDSDK-SPM/Scripts/FirebaseCrashlytics/run"
if [[ -f "$SCRIPT_PATH" ]]; then
    "$SCRIPT_PATH"
else
    echo "warning: Firebase Crashlytics script not found at $SCRIPT_PATH"
fi
```

Requirements:

- Place this phase **after** `Embed Frameworks` / `[CP] Embed Pods Frameworks` (the script needs the dSYM produced by linking)
- Uncheck `Based on dependency analysis`
- Set `User Script Sandboxing` to `NO`
- Add `$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)` and `$(DWARF_DSYM_FOLDER_PATH)/$(DWARF_DSYM_FILE_NAME)` to the script's **Input Files** so it picks up the dSYM correctly

## Notes

- Multi-target apps (App + App Clip + Extensions): every target that needs the resources / schemes must add its own copy of both Run Script Phases
- CI / Xcode Cloud need the same sandbox settings
- `CFBundleURLName` entries prefixed with `xdsdk.` are managed by the script and will be overwritten on every build — edit `XDConfig.json` instead
- Binary distribution: the `.xcframework.zip` files are downloaded from URLs declared in `Package.swift`
