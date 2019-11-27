// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Logbook",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v3)
    ],
    products: [
        .library(name: "Logbook", targets: ["Logbook"])
    ],
    dependencies: [],
    targets: [
        .target(name: "Logbook", dependencies: [], path: "Logbook/Source")
    ],
    swiftLanguageVersions: [.v5]
)
