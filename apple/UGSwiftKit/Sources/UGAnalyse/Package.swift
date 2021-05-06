// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UGAnalyse",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "UGAnalyse",
            targets: ["UGAnalyse"]),
    ],
    dependencies: [
        .package(name: "PerfectSQLite", url: "https://github.com/PerfectlySoft/Perfect-SQLite.git", .branch("master")),
        .package(name: "PythonKit", url: "https://github.com/ubunfork/PythonKit.git", .branch("master")),
//        .package(name: "SwiftCharts", url: "https://github.com/i-schuetz/SwiftCharts.git", .branch("master")),
    ],
    targets: [

        .target(
            name: "UGAnalyse",
            dependencies: [
                "PythonKit",
                "PerfectSQLite",
//                "SwiftCharts",
            ]),
        .testTarget(
            name: "UGAnalyseTests",
            dependencies: ["UGAnalyse"]),
    ]
)
