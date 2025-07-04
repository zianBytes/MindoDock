// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MindoDock",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "MindoDock",
            path: ".",
            exclude: ["Package.swift"],
            resources: [
                .process("Assets.xcassets")
            ]
        )
    ]
) 