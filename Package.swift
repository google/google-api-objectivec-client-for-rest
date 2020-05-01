// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

var products: [PackageDescription.Product] = [
    .library(
        name: "GoogleAPIClientForRESTCore",
        targets: ["GoogleAPIClientForRESTCore"]
    )
]

var targets: [PackageDescription.Target] = [
    .target(
        name: "GoogleAPIClientForRESTCore",
        dependencies: [
            "GTMSessionFetcher"
        ],
        path: "Source",
        exclude: [
            "GeneratedServices",
            "Tests",
            "Tools"
        ],
        sources: [
            "Objects",
            "Utilities"
        ],
        publicHeadersPath: "SwiftPackage",
        cSettings: [
            .headerSearchPath("."),
            .headerSearchPath("Objects"),
            .headerSearchPath("Utilities")
        ]
    ),
    .testTarget(
        name: "GoogleAPIClientForRESTTests",
        dependencies: [
            "GoogleAPIClientForRESTCore"
        ],
        path: "Source/Tests",
        exclude: [
            "CompiledTestNoARC.m"
        ],
        sources: [
            ".",
            "TestingSvc"
        ],
        cSettings: [
            .headerSearchPath("TestingSvc")
        ]
    )
]

let package = Package(
    name: "GoogleAPIClientForREST",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v8),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: products,
    dependencies: [
        .package(url: "https://github.com/google/gtm-session-fetcher.git", from: "1.4.0")
    ],
    targets: targets
)
