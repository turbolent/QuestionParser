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
        .package(url: "https://github.com/turbolent/ParserCombinators.git", .exact("0.1.0")),
    ],
    targets: [
        .target(
            name: "QuestionParser",
            dependencies: ["ParserCombinators"]),
        .testTarget(
            name: "QuestionParserTests",
            dependencies: ["QuestionParser"]),
    ]
)
