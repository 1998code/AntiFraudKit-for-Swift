// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Created by Ming on 25/12/2022.
//

import PackageDescription

let package = Package(
    name: "AntiFraudKit",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "AntiFraudKit",
            targets: ["AntiFraudKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AntiFraudKit",
            dependencies: [])
    ]
)
