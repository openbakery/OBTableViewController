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
            publicHeadersPath: "include",
            cSettings: [
								CSetting.headerSearchPath("Main/Core"),
                CSetting.headerSearchPath("Main/Cell"),
                CSetting.headerSearchPath("Main/Binding"),
                CSetting.headerSearchPath("Main/Model"),
                CSetting.headerSearchPath("Main/OBReflection"),
            ]
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
						CSetting.headerSearchPath("Test/Stubs"),
						CSetting.headerSearchPath("Main/Core"),
						CSetting.headerSearchPath("Main/Cell"),
						CSetting.headerSearchPath("Main/Binding"),
						CSetting.headerSearchPath("Main/Model"),
						CSetting.headerSearchPath("Main/OBReflection"),
					]
				)

		]
)
