// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "Decomposed",
    platforms: [
      .iOS(.v13),
      .macOS(.v11),
      .tvOS(.v13)
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
