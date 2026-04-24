#!/bin/bash
set -euo pipefail

APP_RESOURCES_DIR="${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

if [[ -n "${SOURCE_PACKAGES_DIR_PATH:-}" ]]; then
    SOURCE_PACKAGES_DIR="${SOURCE_PACKAGES_DIR_PATH}"
else
    DERIVED_DATA_DIR="${BUILD_DIR%/Build/*}"
    SOURCE_PACKAGES_DIR="${DERIVED_DATA_DIR}/SourcePackages"
fi

PACKAGE_CHECKOUT_DIR="${SOURCE_PACKAGES_DIR}/checkouts/XDSDK-SPM"

copy_bundle_dir() {
    local source_dir="$1"
    if [[ ! -d "$source_dir" ]]; then
        return
    fi

    find "$source_dir" -maxdepth 1 -type d -name "*.bundle" | while read -r bundle_path; do
        bundle_name="$(basename "$bundle_path")"
        rm -rf "${APP_RESOURCES_DIR}/${bundle_name}"
        cp -R "$bundle_path" "${APP_RESOURCES_DIR}/${bundle_name}"
        echo "Copied ${bundle_name}"
    done
}

copy_bundle_dir "${PACKAGE_CHECKOUT_DIR}/Resources/TapSDK4"
copy_bundle_dir "${PACKAGE_CHECKOUT_DIR}/Resources/CN"
copy_bundle_dir "${PACKAGE_CHECKOUT_DIR}/Resources/Oversea"
