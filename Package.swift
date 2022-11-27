// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode2022",
    products: [
        .executable(name: "AdventOfCode", targets: ["AdventOfCode"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Helpers",
            dependencies: [],
            path: "Sources/Helpers"),
        .executableTarget(
            name: "AdventOfCode",
            dependencies: ["Helpers"],
            path: "Sources/AdventOfCode"),
        .testTarget(
            name: "AdventOfCodeTests",
            dependencies: ["AdventOfCode"]),
        .testTarget(
            name: "HelpersTests",
            dependencies: ["Helpers"]),
    ]
)
