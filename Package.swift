// swift-tools-version: 5.9
import PackageDescription

let version = "7.6.1"
let baseURL = "https://xdsdk-public.oss-cn-beijing.aliyuncs.com/pkg/iOS/SPM/7.6.1"

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
        "XDCommonSDK.xcframework.zip": "e62a74860e2be39fa9e1d5f3fd367c43c9a36cd19467077754a555ed9afefa3d",
        "XDAccountSDK.xcframework.zip": "b87bc9c7a8b17158886c8ecf410d187c63ad57e4672ade6e021081cc18865f5c",
        "XDPaymentSDK.xcframework.zip": "9ccf9c66d70962e2c38539e6aa1c5a4f1977b5f3b9cd9cc2fe576a3d7dbbe239",
        "XDDouyinGameWrapperSDK.xcframework.zip": "d7b8b843f772e363fdfe2497b65c5ecf91eb224000c9e3ada12b110d5cfe6da0",
        "XDCNWrapper.xcframework.zip": "f46886d75abb0aadb4f9a0296526837727d3d946be1b7057a5243b61feeba2a2",
        "XDGlobalWrapper.xcframework.zip": "b923c4cfe8335d16237673a5b2e89c8fda390386e4b4a97699f36d020d863313",
        "XDGlobalWrapperCrashlytics.xcframework.zip": "41712b7d657a3fafa7922c060eb2e2ce48aa3fdc4c54074e92c31b917d311d8d",
        "XDTapSDK4WrapperSDK.xcframework.zip": "583b06c0bf5bf4d6dd0714fcb8eece7e652c5b556b87ceae2e9c86473279f7f4",
        "UnionOpenPlatformCore.xcframework.zip": "19a4e0709501744908932572e65157d6cd7b928f21a2009a3e3596b68935d483",
        "UnionOpenPlatformDataLink.xcframework.zip": "fa7051e6cc99df563e2ba8422c09d6226b3872efbc5d1c624e646bb4b91f7d09",
    ]

    guard let value = checksums[fileName] else {
        preconditionFailure("Missing checksum for \(fileName)")
    }
    return value
}
