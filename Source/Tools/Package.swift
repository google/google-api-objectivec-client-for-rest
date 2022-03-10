// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "GTLR_ServiceGenerator",
    platforms: [
        .macOS(.v10_10),
    ],
    products: [
        .executable(
            name: "ServiceGenerator",
            targets: ["ServiceGenerator"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/google/gtm-session-fetcher.git", "1.6.1" ..< "2.0.0"),
        .package(path: "../..")
    ],
    targets: [
        .target(
            name: "ServiceGenerator",
            dependencies: [
                "ServiceGeneratorLib"
            ],
            path: "SwiftPMShim"
        ),
        .target(
            name: "ServiceGeneratorLib",
            dependencies: [
                "GoogleAPIClientForRESTCore",
                "GoogleAPIClientForREST_Discovery",
                "GTMSessionFetcherCore",
            ],
            path: "ServiceGenerator",
            publicHeadersPath: "Public"
        ),
    ]
)
