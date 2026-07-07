// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "OBTableViewController",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "OBTableViewController", targets: ["OBTableViewController"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/jonreid/OCMockito",
            .upToNextMajor(from: "7.0.0")
        )
    ],
    targets: [
        .target(
            name: "OBTableViewController",
            path: "Framework/Main/Source/",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("./Binding"),
                .headerSearchPath("./Cell"),
                .headerSearchPath("./Core"),
                .headerSearchPath("./Model"),
                .headerSearchPath("./Reflection"),
            ]

        ),
        .testTarget(
            name: "OBTableViewControllerTests",
            dependencies: ["OBTableViewController", "OCMockito"],
            path: "Framework/Test/Source/",
            cSettings: [
                .headerSearchPath("./Binding"),
                .headerSearchPath("./Core"),
                .headerSearchPath("./Stubs"),
                .headerSearchPath("../../Main/Source/Binding"),
                .headerSearchPath("../../Main/Source/Cell"),
                .headerSearchPath("../../Main/Source/Core"),
                .headerSearchPath("../../Main/Source/Model"),
                .headerSearchPath("../../Main/Source/Reflection"),
            ]
        ),

    ]
)
