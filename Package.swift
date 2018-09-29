// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "QuestionParser",
    products: [
        .library(
            name: "QuestionParser",
            targets: ["QuestionParser"]),
    ],
    dependencies: [
        .package(url: "https://github.com/turbolent/SwiftParserCombinators.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "QuestionParser",
            dependencies: ["SwiftParserCombinators"]),
        .testTarget(
            name: "QuestionParserTests",
            dependencies: ["QuestionParser"]),
    ]
)
