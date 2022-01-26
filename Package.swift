// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fipper-swift-sdk",
    products: [
        .library(
            name: "fipper-swift-sdk",
            targets: ["fipper-swift-sdk"]
        ),
    ],
    dependencies: [
        .package(name: "Gzip", url: "https://github.com/1024jp/GzipSwift", from: "5.1.1"),
    ],
    targets: [
        .target(
            name: "fipper-swift-sdk",
            dependencies: ["Gzip"]
        ),
        .testTarget(
            name: "fipper-swift-sdkTests",
            dependencies: ["fipper-swift-sdk"]
        ),
    ]
)
