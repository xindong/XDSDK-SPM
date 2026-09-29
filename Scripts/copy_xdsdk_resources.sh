#!/bin/bash
set -euo pipefail

APP_RESOURCES_DIR="${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
CONFIG_PATH=""
EXTRA_CONFIG_PATHS=()

usage() {
    cat <<'EOF'
Usage:
  copy_xdsdk_resources.sh [--config <XDConfig.json>] [--config-extra <XDConfig.json> ...]

Environment:
  XDSDK_CONFIG_PATH          explicit path to the main XDConfig.json
  XDSDK_EXTRA_CONFIG_PATHS   colon-separated extra XDConfig.json paths
  SRCROOT / PRODUCT_NAME     default config lookup: ${SRCROOT}/${PRODUCT_NAME}/XDConfig.json
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --config)
            if [[ $# -lt 2 || -z "$2" ]]; then
                echo "error: --config requires a path" >&2
                exit 1
            fi
            CONFIG_PATH="$2"
            shift 2
            ;;
        --config-extra)
            if [[ $# -lt 2 || -z "$2" ]]; then
                echo "error: --config-extra requires a path" >&2
                exit 1
            fi
            EXTRA_CONFIG_PATHS+=("$2")
            shift 2
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            echo "error: unknown argument: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

find_main_config() {
    if [[ -n "$CONFIG_PATH" ]]; then
        return
    fi

    if [[ -n "${XDSDK_CONFIG_PATH:-}" ]]; then
        CONFIG_PATH="$XDSDK_CONFIG_PATH"
        return
    fi

    if [[ -n "${SRCROOT:-}" && -n "${PRODUCT_NAME:-}" ]]; then
        local default_path="${SRCROOT}/${PRODUCT_NAME}/XDConfig.json"
        if [[ -f "$default_path" ]]; then
            CONFIG_PATH="$default_path"
            return
        fi
    fi

    if [[ -n "${SRCROOT:-}" && -d "$SRCROOT" ]]; then
        local candidate
        while IFS= read -r candidate; do
            CONFIG_PATH="$candidate"
            return
        done < <(find "$SRCROOT" -type f -name "XDConfig.json" -print)
    fi
}

append_environment_extra_configs() {
    if [[ -z "${XDSDK_EXTRA_CONFIG_PATHS:-}" ]]; then
        return
    fi

    local raw_path
    local env_extra_paths=()
    IFS=':' read -r -a env_extra_paths <<< "$XDSDK_EXTRA_CONFIG_PATHS"
    for raw_path in "${env_extra_paths[@]}"; do
        if [[ -n "$raw_path" ]]; then
            EXTRA_CONFIG_PATHS+=("$raw_path")
        fi
    done
}

read_config_region() {
    local config_path="$1"
    /usr/bin/env python3 - "$config_path" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
try:
    config = json.loads(path.read_text(encoding="utf-8"))
except (OSError, ValueError) as error:
    print("error: failed to read {}: {}".format(path, error), file=sys.stderr)
    sys.exit(1)

region = config.get("region_type")
if isinstance(region, str) and region.lower() == "global":
    print("global")
else:
    print("cn")
PY
}

find_main_config
append_environment_extra_configs

if [[ -z "$CONFIG_PATH" || ! -f "$CONFIG_PATH" ]]; then
    echo "error: XDConfig.json not found (looked at: ${CONFIG_PATH:-<none>})" >&2
    exit 1
fi

NEEDS_CN=0
NEEDS_GLOBAL=0

register_config_region() {
    local config_path="$1"
    if [[ ! -f "$config_path" ]]; then
        echo "error: XDConfig.json not found: $config_path" >&2
        exit 1
    fi

    local region
    region="$(read_config_region "$config_path")"
    case "$region" in
        cn)
            NEEDS_CN=1
            ;;
        global)
            NEEDS_GLOBAL=1
            ;;
        *)
            echo "error: unsupported region '$region' from $config_path" >&2
            exit 1
            ;;
    esac
}

register_config_region "$CONFIG_PATH"
for extra_config_path in "${EXTRA_CONFIG_PATHS[@]-}"; do
    if [[ -z "$extra_config_path" ]]; then
        continue
    fi
    register_config_region "$extra_config_path"
done

if [[ -n "${SOURCE_PACKAGES_DIR_PATH:-}" ]]; then
    SOURCE_PACKAGES_DIR="${SOURCE_PACKAGES_DIR_PATH}"
else
    DERIVED_DATA_DIR="${BUILD_DIR%/Build/*}"
    SOURCE_PACKAGES_DIR="${DERIVED_DATA_DIR}/SourcePackages"
fi

PACKAGE_CHECKOUT_DIR="${SOURCE_PACKAGES_DIR}/checkouts/XDSDK-SPM"

remove_bundle_dir() {
    local source_dir="$1"
    if [[ ! -d "$source_dir" ]]; then
        return
    fi

    local bundle_path
    local bundle_name
    while IFS= read -r -d '' bundle_path; do
        bundle_name="$(basename "$bundle_path")"
        rm -rf "${APP_RESOURCES_DIR:?}/${bundle_name}"
    done < <(find "$source_dir" -maxdepth 1 -type d -name "*.bundle" -print0)
}

copy_bundle_dir() {
    local source_dir="$1"
    if [[ ! -d "$source_dir" ]]; then
        return
    fi

    local bundle_path
    local bundle_name
    while IFS= read -r -d '' bundle_path; do
        bundle_name="$(basename "$bundle_path")"
        cp -R "$bundle_path" "${APP_RESOURCES_DIR}/${bundle_name}"
        echo "Copied ${bundle_name}"
    done < <(find "$source_dir" -maxdepth 1 -type d -name "*.bundle" -print0)
}

mkdir -p "$APP_RESOURCES_DIR"

remove_bundle_dir "${PACKAGE_CHECKOUT_DIR}/Resources/TapSDK4"
remove_bundle_dir "${PACKAGE_CHECKOUT_DIR}/Resources/CN"
remove_bundle_dir "${PACKAGE_CHECKOUT_DIR}/Resources/Oversea"

copy_bundle_dir "${PACKAGE_CHECKOUT_DIR}/Resources/TapSDK4"

if [[ $NEEDS_CN -eq 1 ]]; then
    copy_bundle_dir "${PACKAGE_CHECKOUT_DIR}/Resources/CN"
fi

if [[ $NEEDS_GLOBAL -eq 1 ]]; then
    copy_bundle_dir "${PACKAGE_CHECKOUT_DIR}/Resources/Oversea"
fi
