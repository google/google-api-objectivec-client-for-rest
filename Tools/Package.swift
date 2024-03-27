// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "GTLR_ServiceGenerator",
    platforms: [
        .macOS(.v10_12),
    ],
    products: [
        .executable(
            name: "ServiceGenerator",
            targets: ["ServiceGenerator"]
        ),
    ],
    dependencies: [
        .package(path: "..")
    ],
    targets: [
        .target(
            name: "ServiceGenerator",
            dependencies: ["ServiceGeneratorLib"],
            path: "SwiftPMShim"
        ),
        .target(
            name: "ServiceGeneratorLib",
            dependencies: [
                "GoogleAPIClientForRESTCore",
                "GoogleAPIClientForREST_Discovery",
            ],
            path: "ServiceGenerator",
            publicHeadersPath: "Public"
        ),
    ]
)
