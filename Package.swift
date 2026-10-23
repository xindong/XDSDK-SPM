// swift-tools-version: 5.9
import PackageDescription

let version = "7.9.3"
let baseURL = "https://xdsdk-public.oss-cn-beijing.aliyuncs.com/pkg/iOS/SPM/7.9.3"

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
        "XDCommonSDK.xcframework.zip": "ae3833cb48d843ba1fa7a5317053b28656052fd60160f136ed99cac24252e3f3",
        "XDAccountSDK.xcframework.zip": "2169592f01e444416e5f62aecaec2026e68903967f4936beaeb56cc7bb40e23a",
        "XDPaymentSDK.xcframework.zip": "64ad6a97c1c84651bcd15a5624384fa88d62fef07d5be9031862ac78e340282d",
        "XDDouyinGameWrapperSDK.xcframework.zip": "8ef0244e08b5ff0af666d34ecfa0e0f2b4b396922a616affe51cde5d72c83410",
        "XDCNWrapper.xcframework.zip": "458808f622bb1269305ea62004a80c32346ebfbbf9a74026c42d21c1bef04682",
        "XDGlobalWrapper.xcframework.zip": "dc6d78bf9233ee676f79451e5e4e28074cca8104e5af19d805ca6fc9f4fa60da",
        "XDGlobalWrapperCrashlytics.xcframework.zip": "fdaf9ef8291b05f42274156837fa93dc83dad460f49f4c36c17b5798ecdd60e9",
        "XDTapSDK4WrapperSDK.xcframework.zip": "a8e5a4dd73267353a6c74476a5b714f416d0ada4b02481f616d6eec8d5b1ba4a",
        "UnionOpenPlatformCore.xcframework.zip": "c7e2e6841d89363fb9fd87aa693c5df1c75f55351dea886c81b865c48236255a",
        "UnionOpenPlatformDataLink.xcframework.zip": "8810fda09e3ecde14ecf5de979d34e931949ee57aaf73a0483f08dec708f03d9",
    ]

    guard let value = checksums[fileName] else {
        preconditionFailure("Missing checksum for \(fileName)")
    }
    return value
}
