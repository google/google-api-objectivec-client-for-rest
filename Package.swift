// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

/// Helper class used to generate ` Product` and `Target` of services.
final class GeneratedService: Encodable {
    let product: PackageDescription.Product
    let target: PackageDescription.Target

    private init(name: String, dependencies: [PackageDescription.Target.Dependency]) {
        let serviceName = "GoogleAPIClientForREST" + name
        let servivePath = "Source/GeneratedServices/" + name
        product = .library(
            name: serviceName,
            targets: [serviceName]
        )
        target = .target(
            name: serviceName,
            dependencies: dependencies,
            path: servivePath,
            publicHeadersPath: "."
        )
    }

    static func service(name: String, dependencies: [PackageDescription.Target.Dependency] = ["GoogleAPIClientForRESTCore"]) -> Self {
        return Self.init(name: name, dependencies: dependencies)
    }
}

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

/// All the services.
let generatedServices: [GeneratedService] = [
]

for generatedService in generatedServices {
    products.append(generatedService.product)
    targets.append(generatedService.target)
}

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
