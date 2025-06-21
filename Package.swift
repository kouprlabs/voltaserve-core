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
    dependencies: [],
    targets: [
        .target(
            name: "VoltaserveCore",
            dependencies: [],
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
