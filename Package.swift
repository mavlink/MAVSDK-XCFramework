// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "MAVSDK-XCFramework",
  products: [
    .library(
      name: "mavsdk_server",
      targets: ["mavsdk_server"]),
  ],
  targets: [
    .binaryTarget(name: "mavsdk_server",
                  url: "https://github.com/mavlink/MAVSDK/releases/download/v0.41.0/mavsdk_server.xcframework.zip",
                  checksum: "497b6b7ab1599b054473e25cd0705039d44746f1ed77e4f2287b29d185f1ce36")
  ]
)
