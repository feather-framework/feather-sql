// swift-tools-version:6.3
import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .strictMemorySafety(),
    .treatAllWarnings(as: .error),
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("ImmutableWeakCaptures"),
    .enableUpcomingFeature("StrictConcurrency"),
    .enableExperimentalFeature("SuppressedAssociatedTypes"),
    .enableExperimentalFeature("LifetimeDependence"),
    .enableExperimentalFeature("Lifetimes"),
]

let package = Package(
    name: "feather-sql",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "FeatherSQL", targets: ["FeatherSQL"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-collections",
            from: "1.7.0"
        )
    ],
    targets: [
        .target(
            name: "FeatherSQL",
            dependencies: [
                .product(
                    name: "OrderedCollections",
                    package: "swift-collections"
                )
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "FeatherSQLTests",
            dependencies: ["FeatherSQL"],
            swiftSettings: swiftSettings
        ),
    ]
)
