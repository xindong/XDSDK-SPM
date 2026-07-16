// swift-tools-version: 5.9
import PackageDescription

let version = "7.7.3"
let baseURL = "https://xdsdk-public.oss-cn-beijing.aliyuncs.com/pkg/iOS/SPM/7.7.3"

let package = Package(
    name: "XDSDKBinary",
    platforms: [
        .iOS(.v11)
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
        "XDCommonSDK.xcframework.zip": "2f45318bff25509cde5b0c6cfbe7cc44e89f4b868e22acebbb4a8b38b9d4c636",
        "XDAccountSDK.xcframework.zip": "4ebb103d06dbaaad2152ec6445d5d711c2f5853c2eac4390b3a0bba15bd3a6ba",
        "XDPaymentSDK.xcframework.zip": "a977dfcbda4db794cb4eb9eb7b8e535e7008e06f13f6d2a3ab91208c30d72a9f",
        "XDDouyinGameWrapperSDK.xcframework.zip": "1ea971cfc07e9d925e5d98eb54ece6447de9b0206f699334841610ae10df822d",
        "XDCNWrapper.xcframework.zip": "8a815397851a3013854c74c3e84321ef6cc44f5b78ac20e7117855c13cb8096e",
        "XDGlobalWrapper.xcframework.zip": "1ee14ff676bbb0837830b9813f74c921d4a1214cc24801a17b1ce59d9275c431",
        "XDGlobalWrapperCrashlytics.xcframework.zip": "77d23b9afc33b1e7fdd32049d0570283c91aea918690b36d26d0437700cd391e",
        "XDTapSDK4WrapperSDK.xcframework.zip": "02b261ef8838388bde8241893d5cb8f04a8f3ab3f7f0f557ddec758b4fa898e0",
        "UnionOpenPlatformCore.xcframework.zip": "f86e43a56110edbca387c71d487823d6ab045db0dfafdd30b36ea7551d574ca8",
        "UnionOpenPlatformDataLink.xcframework.zip": "3a05b4ec08d6b984ca3f99261d4a46bac8535db629173b4cea552584d9b2df15",
    ]

    guard let value = checksums[fileName] else {
        preconditionFailure("Missing checksum for \(fileName)")
    }
    return value
}
