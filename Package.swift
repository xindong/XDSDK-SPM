// swift-tools-version: 5.9
import PackageDescription

let version = "7.8.0"
let baseURL = "https://xdsdk-public.oss-cn-beijing.aliyuncs.com/pkg/iOS/SPM/7.8.0"

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
        "XDCommonSDK.xcframework.zip": "f6aa320d87413513efa082923e59b0a7af1188a8df9c22d8f49530d2bf76f3ad",
        "XDAccountSDK.xcframework.zip": "592cf94189fe921a0f1b20c73a8bedccc12aebd69d5b42bd55719b4b99c4ee6a",
        "XDPaymentSDK.xcframework.zip": "b3b3f8b51e6cc740d4ebbad05d9f44d694e111580fb8485ad65ebd15c78a9c2f",
        "XDDouyinGameWrapperSDK.xcframework.zip": "fa207e0c02b0e2a8ac7e18ee66305d98de55f4915ac31329364ca330051a7da6",
        "XDCNWrapper.xcframework.zip": "87f4da33383b7d6fa4a6333523156d3f0db2dd927cefa8ff507b507e1bdf5adf",
        "XDGlobalWrapper.xcframework.zip": "b2ec5e23c6394e29571ec98cd3df94897acd35e6d551f9520ee8b5f82214249a",
        "XDGlobalWrapperCrashlytics.xcframework.zip": "b38c56c7626f4ca23f5f21beb4bf4a970e5e1f834590e0ea4262c12f6a5a14a3",
        "XDTapSDK4WrapperSDK.xcframework.zip": "9caf9a1bdd89e227a6a4d5b45eb80f079ec66db0b1348eeff72fb767d1280e5b",
        "UnionOpenPlatformCore.xcframework.zip": "b26d2e1558c1f341e27c01ec57dad79cc3eb1bef1418d2e239dc39e3f23bb8e0",
        "UnionOpenPlatformDataLink.xcframework.zip": "abd3b8f074f90aea584922ba186636a2b6eef06f455f7f2add15ae4bd97e9afa",
    ]

    guard let value = checksums[fileName] else {
        preconditionFailure("Missing checksum for \(fileName)")
    }
    return value
}
