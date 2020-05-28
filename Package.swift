// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Decomposed",
    platforms: [
      .iOS(.v10),
      .macOS(.v10_12),
      .tvOS(.v10)
    ],
    products: [
        .library(
            name: "Decomposed",
            targets: ["Decomposed"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Decomposed",
            dependencies: [],
            exclude: [
                "Objective-C Support",
            ]),
        .testTarget(
            name: "DecomposedTests",
            dependencies: ["Decomposed"]),
    ],
    swiftLanguageVersions: [.v5]
)
