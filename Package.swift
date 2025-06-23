// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "VoltaserveCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "VoltaserveCore",
            targets: ["VoltaserveCore"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.3.2"),
        .package(url: "https://github.com/warrenm/GLTFKit2.git", from: "0.5.11"),
    ],
    targets: [
        .target(
            name: "VoltaserveCore",
            dependencies: ["Kingfisher", "GLTFKit2"],
            path: "Sources",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "VoltaserveTests",
            dependencies: ["VoltaserveCore"],
            path: "Tests",
            resources: [.process("Resources")]
        ),
    ]
)
