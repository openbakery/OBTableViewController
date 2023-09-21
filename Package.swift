// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "OBTableViewController",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "OBTableViewController", targets: ["OBTableViewController"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/jonreid/OCMockito",
            .upToNextMajor(from: "7.0.0")
        ),
    ],
    targets: [
        .target(
            name: "OBTableViewController",
						path: "Framework",
            exclude: [
            ],
            sources: [
                "Main",
            ],
            publicHeadersPath: "Headers",
            cSettings: [
              CSetting.headerSearchPath("Source/Binding"),
              CSetting.headerSearchPath("Source/Cell"),
              CSetting.headerSearchPath("Source/Core"),
              CSetting.headerSearchPath("Source/Reflection"),
              CSetting.headerSearchPath("Source")
            ]
            ),
				.testTarget(
					name: "OBTableViewControllerTests",
					dependencies: ["OBTableViewController", "OCMockito"],
					path: "Framework",
					exclude: [
					],
					sources: [
							"Test",
					],
					cSettings: [
						CSetting.headerSearchPath("Test/Binding"),
						CSetting.headerSearchPath("Test/Core"),
						CSetting.headerSearchPath("Test/Stubs")
					]
				)

		]
)
