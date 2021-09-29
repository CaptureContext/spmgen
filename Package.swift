// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "spmgen",
  products: [
    .executable(
      name: "spmgen",
      targets: [
        "SPMGen"
      ]
    )
  ],
  dependencies: [
    .package(
      name: "swift-package-resources",
      url: "https://github.com/capturecontext/swift-package-resources.git",
      .upToNextMajor(from: "1.0.0")
    ),
    .package(
      name: "swift-argument-parser",
      url: "https://github.com/apple/swift-argument-parser.git",
      from: "1.0.1"
    ),
    .package(
      name: "Files",
      url: "https://github.com/JohnSundell/Files.git",
      from: "4.0.0"
    ),
  ],
  targets: [
    .target(
      name: "SPMGen",
      dependencies: [
        .target(name: "SPMGenLib")
      ]
    ),
    .target(
      name: "SPMGenLib",
      dependencies: [
        .product(
          name: "PackageResources",
          package: "swift-package-resources"
        ),
        .product(
          name: "ArgumentParser",
          package: "swift-argument-parser"
        ),
        .product(
          name: "Files",
          package: "Files"
        ),
      ]
    ),
    .testTarget(
      name: "SPMGenLibTests",
      dependencies: [
        .target(name: "SPMGenLib"),
        .product(
          name: "PackageResources",
          package: "swift-package-resources"
        ),
      ]
    )
  ]
)
