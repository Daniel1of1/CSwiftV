// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "CSwiftV",
    products: [
        .library(
            name: "CSwiftV",
            targets: ["CSwiftV"]),
    ],
    targets: [
        .target(
            name: "CSwiftV",
            dependencies: []),
        .testTarget(
            name: "CSwiftVTests",
            dependencies: ["CSwiftV"]),
    ]
)
