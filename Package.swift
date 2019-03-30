// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "QuestionParser",
    products: [
        .library(
            name: "QuestionParser",
            targets: ["QuestionParser"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/turbolent/ParserCombinators.git", from: "0.3.0"),
        .package(url: "https://github.com/turbolent/DiffedAssertEqual.git", from: "0.2.0"),
    ],
    targets: [
        .target(
            name: "QuestionParser",
            dependencies: ["ParserCombinators", "ParserCombinatorOperators"]
        ),
        .testTarget(
            name: "QuestionParserTests",
            dependencies: ["QuestionParser", "DiffedAssertEqual"]
        ),
    ]
)
