// swift-tools-version: 5.9
import PackageDescription

let version = "7.7.0"
let baseURL = "https://xdsdk-public.oss-cn-beijing.aliyuncs.com/pkg/iOS/SPM/7.7.0"

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
        "XDCommonSDK.xcframework.zip": "00707d7728f5957257d12a08fb7aed8e76bda6f0853275b7a276a543d623995c",
        "XDAccountSDK.xcframework.zip": "98c84a9ebb870902771d6f6452ca9fb8a343392ef719aa8bc77226c928947071",
        "XDPaymentSDK.xcframework.zip": "151c202bb33d432619197051fc78c567736ba43365c90d200247a5357b3a0082",
        "XDDouyinGameWrapperSDK.xcframework.zip": "5ce9860e96bfcdd097d8ddb0c971026154b9589d1173d42e0754f1f9b476f8a4",
        "XDCNWrapper.xcframework.zip": "f3a3409f0b3a8247c1bb0f1376979a6462a418b7f2f917a4675778657bf5f773",
        "XDGlobalWrapper.xcframework.zip": "3a4c07c63c1e5c2ef24b1944f9bb7755b22cf3bea2d8a0c6b2b68159239e2b76",
        "XDGlobalWrapperCrashlytics.xcframework.zip": "55ae9f3dc67aeaec12fc806303c9a7cf120c621a1bbd04ea4cbd09b3cf20e8c2",
        "XDTapSDK4WrapperSDK.xcframework.zip": "4dd8723119ca6592fadf4eb79affef41332068b36bbd3cb3bf38f969d521b644",
        "UnionOpenPlatformCore.xcframework.zip": "4457ba73f446b80ed33fee563149668daba346224fcc2443f85150ef16c13169",
        "UnionOpenPlatformDataLink.xcframework.zip": "8f82de4c07d45939ab172205c3ccad20541b4fce4208676684ee3c2095e9de70",
    ]

    guard let value = checksums[fileName] else {
        preconditionFailure("Missing checksum for \(fileName)")
    }
    return value
}
