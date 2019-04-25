// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "CSwiftV",
    products: [
      .library(name: "CSwiftV", targets: ["CSwiftV"])
    ],
    targets: [
      .target(
          name: "CSwiftV",
          dependencies: [],
          path: "Sources"
      )
    ]
)

