// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "LimitChecker",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "LimitChecker", targets: ["LimitChecker"]),
        .executable(name: "LimitProbe", targets: ["LimitProbe"]),
    ],
    targets: [
        .executableTarget(name: "LimitChecker"),
        .executableTarget(name: "LimitProbe"),
    ]
)
