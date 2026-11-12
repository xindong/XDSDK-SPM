// swift-tools-version: 5.9
import PackageDescription

let version = "7.11.0"
let baseURL = "https://xdsdk-public.oss-cn-beijing.aliyuncs.com/pkg/iOS/SPM/7.11.0"

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
        "XDCommonSDK.xcframework.zip": "2888f0a929e95b73803498e75b3d76cf068ff1bf3a1b3d55836094ab9382c4f4",
        "XDAccountSDK.xcframework.zip": "d659af4a9b716faa7156ee363b7cc5f0825b778868f554a12ef88792bcafc0f0",
        "XDPaymentSDK.xcframework.zip": "9f3f900caa7ec220f95c99684b2cbeb5c99f8b1a83bcd280c6736d65c8e364c1",
        "XDDouyinGameWrapperSDK.xcframework.zip": "450ec41e6f1d4cef20b1a544049ee2347b4e3494be4f4f28c50615bfdcf10d31",
        "XDCNWrapper.xcframework.zip": "f39ea5f115eafe292fa5a50f21958b96d535324191d736e16978cdb213458ccc",
        "XDGlobalWrapper.xcframework.zip": "151eb005fe9d26500c30ea3d24771f3a3c41a7caba90f6af2da0b377369005d6",
        "XDGlobalWrapperCrashlytics.xcframework.zip": "092849a61b63a3d6895f566a5ec44f5f038364adf3e6f16c40497b65db8d63e6",
        "XDTapSDK4WrapperSDK.xcframework.zip": "d3d0e4916e8eae4e761ec5f29aa25f17b2295d4526e243f6d139f276d875f77e",
        "UnionOpenPlatformCore.xcframework.zip": "a13a858e1bdc34f770051ff3671ea39026763fe9a0f41f9e2b28d0d2f9233542",
        "UnionOpenPlatformDataLink.xcframework.zip": "e6457c7ae0698e687e8fde924e9b347c726b6f90f2c81e403b2ac952193cb89c",
    ]

    guard let value = checksums[fileName] else {
        preconditionFailure("Missing checksum for \(fileName)")
    }
    return value
}
