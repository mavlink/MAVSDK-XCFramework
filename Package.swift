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
                  url: "https://github.com/mavlink/MAVSDK/releases/download/v0.40.0/mavsdk_server.xcframework.zip",
                  checksum: "1aa55c2f3d55b0513a6d8e3715f5ec8ea13e07c81d663baa74013de8d4efaa94")
  ]
)
