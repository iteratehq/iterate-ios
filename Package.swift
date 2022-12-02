// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "Iterate",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Iterate",
            targets: ["Iterate"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Iterate",
            dependencies: [],
            path: "IterateSDK",
            exclude: ["Info.plist"],
            resources: [
                .process("Info.plist"),
                .process("SDK/UI/Assets.xcassets"),
                .process("SDK/UI/Surveys.storyboard"),
            ]
        ),
        .testTarget(
            name: "IterateSDKTests",
            dependencies: ["Iterate"],
            path: "IterateSDKTests"
        ),
    ]
)
