// swift-tools-version:4.1

import PackageDescription

let package = Package(
    // 1
    name: "KituraTIL",
    dependencies: [
        // 2
        .package(url: "https://github.com/IBM-Swift/Kitura.git",
                 .upToNextMinor(from: "2.1.0")),
        // 3
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git",
                 .upToNextMinor(from: "1.7.1")),
        // 4
        .package(url: "https://github.com/IBM-Swift/Kitura-CouchDB.git",
                 .upToNextMinor(from: "2.0.1")),
        ],
    //5
    targets: [
        .target(name: "KituraTIL",
                dependencies: ["Kitura" , "HeliumLogger", "CouchDB"],
                path: "Sources")
    ]
)
