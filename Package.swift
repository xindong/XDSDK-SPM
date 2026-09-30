// swift-tools-version: 5.9
import PackageDescription

let version = "7.9.0"
let baseURL = "https://xdsdk-public.oss-cn-beijing.aliyuncs.com/pkg/iOS/SPM/7.9.0"

let package = Package(
    name: "XDSDKBinary",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "XDSDKCN", targets: ["XDCommonSDK", "XDAccountSDK", "XDTapSDK4WrapperSDK", "XDCNWrapper", "XDPaymentSDK"]),
        .library(name: "XDSDKGlobal", targets: ["XDCommonSDK", "XDAccountSDK", "XDTapSDK4WrapperSDK", "XDGlobalWrapper", "XDPaymentSDK"]),
        .library(name: "XDSDKGlobalCrashlytics", targets: ["XDCommonSDK", "XDAccountSDK", "XDTapSDK4WrapperSDK", "XDGlobalWrapperCrashlytics", "XDPaymentSDK"]),
        .library(name: "XDSDKDouYinGame", targets: ["XDCommonSDK", "XDDouyinGameWrapperSDK", "UnionOpenPlatformCore", "UnionOpenPlatformDataLink"]),
    ],
    targets: [
        .binaryTarget(
            name: "XDCommonSDK",
            url: "\(baseURL)/XDCommonSDK.xcframework.zip",
            checksum: checksum("XDCommonSDK.xcframework.zip")
        ),
        .binaryTarget(
            name: "XDAccountSDK",
            url: "\(baseURL)/XDAccountSDK.xcframework.zip",
            checksum: checksum("XDAccountSDK.xcframework.zip")
        ),
        .binaryTarget(
            name: "XDPaymentSDK",
            url: "\(baseURL)/XDPaymentSDK.xcframework.zip",
            checksum: checksum("XDPaymentSDK.xcframework.zip")
        ),
        .binaryTarget(
            name: "XDDouyinGameWrapperSDK",
            url: "\(baseURL)/XDDouyinGameWrapperSDK.xcframework.zip",
            checksum: checksum("XDDouyinGameWrapperSDK.xcframework.zip")
        ),
        .binaryTarget(
            name: "XDCNWrapper",
            url: "\(baseURL)/XDCNWrapper.xcframework.zip",
            checksum: checksum("XDCNWrapper.xcframework.zip")
        ),
        .binaryTarget(
            name: "XDGlobalWrapper",
            url: "\(baseURL)/XDGlobalWrapper.xcframework.zip",
            checksum: checksum("XDGlobalWrapper.xcframework.zip")
        ),
        .binaryTarget(
            name: "XDGlobalWrapperCrashlytics",
            url: "\(baseURL)/XDGlobalWrapperCrashlytics.xcframework.zip",
            checksum: checksum("XDGlobalWrapperCrashlytics.xcframework.zip")
        ),
        .binaryTarget(
            name: "XDTapSDK4WrapperSDK",
            url: "\(baseURL)/XDTapSDK4WrapperSDK.xcframework.zip",
            checksum: checksum("XDTapSDK4WrapperSDK.xcframework.zip")
        ),
        .binaryTarget(
            name: "UnionOpenPlatformCore",
            url: "\(baseURL)/UnionOpenPlatformCore.xcframework.zip",
            checksum: checksum("UnionOpenPlatformCore.xcframework.zip")
        ),
        .binaryTarget(
            name: "UnionOpenPlatformDataLink",
            url: "\(baseURL)/UnionOpenPlatformDataLink.xcframework.zip",
            checksum: checksum("UnionOpenPlatformDataLink.xcframework.zip")
        ),
    ]
)

private func checksum(_ fileName: String) -> String {
    let checksums: [String: String] = [
        "XDCommonSDK.xcframework.zip": "63aff6c2751948b20608992a29d88daa167f6efd5f73dca71538618fde8960df",
        "XDAccountSDK.xcframework.zip": "c19aed6e1d4b2db2d52f32b8a4c687fea3e0a4b9041a0d0d302ff3871161cdc6",
        "XDPaymentSDK.xcframework.zip": "3f550af6aa3082309da595cb1be10f3983496f4fc6af7a2c03081207845ea824",
        "XDDouyinGameWrapperSDK.xcframework.zip": "4298897c4e9b4e7b538dd5efbab89ac9d433e1c06278b76cc3c0b3df38c50328",
        "XDCNWrapper.xcframework.zip": "d3fb856172e7f6a09313781f69895ec95e2546997b98834d647040f62a25ad89",
        "XDGlobalWrapper.xcframework.zip": "4e14389e5e3345eb348c7f0dad59b5c242e9f0108e21c56d4d7f4a2b5a4a6c57",
        "XDGlobalWrapperCrashlytics.xcframework.zip": "856130107514a24993395e9c48120ee3944cf1e4d067de7fec2c71f4592fdcc9",
        "XDTapSDK4WrapperSDK.xcframework.zip": "476eb4413144e81eaac7fdd8bd8b32582c9f46b7884c88226311efae397606f8",
        "UnionOpenPlatformCore.xcframework.zip": "28180a1a6b7fa3b9f3fd063e07f8db16fac043c0a4151a90caa0598887c86613",
        "UnionOpenPlatformDataLink.xcframework.zip": "0772ea45cda3b556481a11196b254ec3683578095813a7d04728e72a208a81a5",
    ]

    guard let value = checksums[fileName] else {
        preconditionFailure("Missing checksum for \(fileName)")
    }
    return value
}
