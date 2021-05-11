// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UGSwiftKit",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "UGSwiftKit",
            targets: ["UGSwiftKit"]),
    ],
    dependencies: [
 
    ],
    targets: [
      
        .target(
            name: "UGSwiftKit",
            dependencies: []),
        .testTarget(
            name: "UGSwiftKitTests",
            dependencies: ["UGSwiftKit"]),
    ]
)
