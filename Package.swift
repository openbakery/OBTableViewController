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
            dependencies: ["OCMockito"],
						path: "OBTableViewController",
            exclude: [
            ],
            sources: [
                "Main",
            ],
            publicHeadersPath: "Headers"
        ),
				.testTarget(
					name: "OBTableViewControllerTests",
					dependencies: ["OBTableViewController"],
					path: "OBTableViewController",
					exclude: [
					],
					sources: [
							"Test",
					],
					cSettings: [
						CSetting.headerSearchPath("Test/Core"),
						CSetting.headerSearchPath("Test/Stubs")
					]
				)

		]
)
