// swift-tools-version:5.6

import PackageDescription

let package = Package(
  name: "spmgen",
  platforms: [
    .macOS(.v11)
  ],
  products: [
    .plugin(
      name: "spmgen-plugin",
      targets: ["spmgen-plugin"]
    ),
    .library(
      name: "SPMGenClient",
      targets: ["SPMGenClient"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/capturecontext/swift-package-resources.git",
      .upToNextMajor(from: "2.0.0")
    ),
    .package(
      url: "https://github.com/apple/swift-argument-parser.git",
      .upToNextMajor(from: "1.0.1")
    ),
    .package(
      url: "https://github.com/capturecontext/swift-prelude.git",
      .upToNextMinor(from: "0.0.1")
    ),
  ],
  targets: [
    .plugin(
      name: "spmgen-plugin",
      capability: .buildTool(),
      dependencies: [
        .target(name: "SPMGenClient")
      ]
    ),
    .executableTarget(
      name: "spmgen",
      dependencies: [
        .target(name: "SPMGenClient"),
        .product(
          name: "ArgumentParser",
          package: "swift-argument-parser"
        ),
      ]
    ),
    .target(
      name: "SPMGenClient",
      dependencies: [
        .product(
          name: "PackageResourcesCore",
          package: "swift-package-resources"
        ),
        .product(
          name: "Prelude",
          package: "swift-prelude"
        )
      ]
    ),
    .testTarget(
      name: "SPMGenClientTests",
      dependencies: [
        .target(name: "SPMGenClient")
      ]
    )
  ]
)
