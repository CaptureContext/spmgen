// swift-tools-version:5.8

import PackageDescription

let package = Package(
  name: "SPMGenExample",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
  ],
  products: [
    .library(
      name: "AppFeature",
      targets: [
        "AppFeature"
      ]
    )
  ],
  dependencies: [
    .package(path: "../"),
    .package(
      url: "https://github.com/capturecontext/swift-foundation-extensions.git",
      from: "0.2.0"
    ),
    .package(
      url: "https://github.com/capturecontext/swift-package-resources.git",
      from: "3.0.0"
    )
  ],
  targets: [
    .target(
      name: "AppExtensions",
      dependencies: [
        .product(
          name: "FoundationExtensions",
          package: "swift-foundation-extensions"
        ),
      ]
    ),
    .target(
      name: "AppFeature",
      dependencies: [
        .target(name: "AppResources")
      ]
    ),
    .target(
      name: "AppResources",
      dependencies: [
        .target(name: "AppExtensions"),
        .product(
          name: "PackageResources",
          package: "swift-package-resources"
        ),
      ],
      resources: [
        .process("Resources")
      ],
      plugins: [
        .plugin(
          name: "spmgen-plugin",
          package: "spmgen"
        )
      ]
    ),
  ]
)
