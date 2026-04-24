// swift-tools-version: 5.9
import PackageDescription

let version = "7.3.2"
let baseURL = "https://xdsdk-public.oss-cn-beijing.aliyuncs.com/pkg/iOS/SPM/7.3.2"

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
        "XDCommonSDK.xcframework.zip": "17ff56050993f308ebb2a9c7f9ab9b0d25d43e5965e435766806f0f0d69132aa",
        "XDAccountSDK.xcframework.zip": "b5b13d01a691724ac731b749cb56b1a532819cb4b65ba9ef7841637453664818",
        "XDPaymentSDK.xcframework.zip": "f2b9632959d80a871ea2ecebd6be9af07f6fbe75d18b0a4039b95d48700c5cec",
        "XDDouyinGameWrapperSDK.xcframework.zip": "dbe699378f280401c277c1ea136a9b3cf96f400ec80de2fa541eba20fc84b380",
        "XDCNWrapper.xcframework.zip": "e5db67ab2295c93b3a28ee02a7742e07b1c0d6870e96d88116e65831e7cb909f",
        "XDGlobalWrapper.xcframework.zip": "4090d0715e6f847de41cc8de0a1c4ceb09cec45d821a428799ddd1bb01096e43",
        "XDGlobalWrapperCrashlytics.xcframework.zip": "384a01cdf3b715e874ea6492644b9de7c66517e61dcf92c4a8aa2e2bc6e7c72d",
        "XDTapSDK4WrapperSDK.xcframework.zip": "1763adc646d5d92f1e1cb151f7becd9c3b60a34374f1a18f2da4d5c61fe80cfe",
        "UnionOpenPlatformCore.xcframework.zip": "8d3d88f86ee43268c9bd36eb5e5b7522273f5396ba6a89a4bddea5f3fd8c55fd",
        "UnionOpenPlatformDataLink.xcframework.zip": "385270e9e83b372170dc6ecfef5cb93e3cf5e2cb1b3d215d50fceb6b0519b77c",
    ]

    guard let value = checksums[fileName] else {
        preconditionFailure("Missing checksum for \(fileName)")
    }
    return value
}
