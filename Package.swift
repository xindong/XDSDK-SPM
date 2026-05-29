// swift-tools-version: 5.9
import PackageDescription

let version = "7.6.3"
let baseURL = "https://xdsdk-public.oss-cn-beijing.aliyuncs.com/pkg/iOS/SPM/7.6.3"

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
        "XDCommonSDK.xcframework.zip": "0f5bd51c374ab778b84efdc1d0d2f36fb6763553394a55275136854dd5b50636",
        "XDAccountSDK.xcframework.zip": "a03be0f683486ddfaef52f5f80572380aceb223d521b40718e9207ec014009ea",
        "XDPaymentSDK.xcframework.zip": "8816b8d35beff0b6ad2448ccf5da7e5daf702f847c69a88107f33072bd31fe5a",
        "XDDouyinGameWrapperSDK.xcframework.zip": "e7ac76ab5dcd09f34000ea8e3e3bc730aece7350b1451866bb800ee8b1f1beec",
        "XDCNWrapper.xcframework.zip": "b9f3c38a8f9ffcdf14b326480a73d42aed7b8583ac61b9fabd6d441b1bb913d5",
        "XDGlobalWrapper.xcframework.zip": "5d050d8d7d2f2a06f57dfac486183c6a795a36a08f2bd5bf12a06274908654c8",
        "XDGlobalWrapperCrashlytics.xcframework.zip": "693778763123fdaaee251f14ee6275a01db4e12b3ba8bdcb214421ec43fd37bb",
        "XDTapSDK4WrapperSDK.xcframework.zip": "5140c401489ab3888b5e591fd73a387343d206b00199e31954be3c456ce40342",
        "UnionOpenPlatformCore.xcframework.zip": "0521169751ce2bca056ca8b0870effbc99f3f11d07cdfedc11cc37da2e020f50",
        "UnionOpenPlatformDataLink.xcframework.zip": "888350cbb06da8cc7b135bd319f4eb9b646412e8f155643a32bc5cb9263e4d2c",
    ]

    guard let value = checksums[fileName] else {
        preconditionFailure("Missing checksum for \(fileName)")
    }
    return value
}
