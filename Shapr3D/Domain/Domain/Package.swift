// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Entities",
            targets: ["Entities"]
        ),
        .library(
            name: "Protocols",
            targets: ["Protocols"]
        ),
        .library(
            name: "UseCases",
            targets: ["UseCases"]
        ),
        .library(
            name: "UseCasesProtocols",
            targets: ["UseCasesProtocols"]
        ),
        
    ],
    dependencies: [
        .package(name: "Utils", path: "../Utils"),
        .package(path: "../Common"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Entities",
            dependencies: [ .product(name: "Utils", package: "Utils"), "Common",]
        ),
        .target(
            name: "Protocols",
            dependencies: [ .product(name: "Utils", package: "Utils"),"Entities",  "Common"]
        ),
        .target(
            name: "UseCases",
            dependencies: [ .product(name: "Utils", package: "Utils"),"Entities",  "Common", "Protocols", "UseCasesProtocols"]
        ),
        .target(
            name: "UseCasesProtocols",
            dependencies: [ .product(name: "Utils", package: "Utils"),"Entities",  "Common", "Protocols"]
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: []),
    ]
)
