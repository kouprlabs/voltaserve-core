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
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.3.2")
    ],
    targets: [
        .target(
            name: "VoltaserveCore",
            dependencies: ["Kingfisher"],
            path: "Sources"
        ),
        .testTarget(
            name: "VoltaserveTests",
            dependencies: ["VoltaserveCore"],
            path: "Tests",
            resources: [.process("Resources")]
        ),
    ]
)
