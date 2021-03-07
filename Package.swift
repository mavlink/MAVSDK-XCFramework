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
                  url: "https://github.com/mavlink/MAVSDK/releases/download/v0.37.0/mavsdk_server.xcframework.zip",
                  checksum: "7c7c45c4f4ae59a93d6cb5d29d2ccede2424108dc549ce94f7ccd834466de51a")
  ]
)
