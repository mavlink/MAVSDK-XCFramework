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
                  url: "https://github.com/mavlink/MAVSDK/releases/download/v0.39.0/mavsdk_server.xcframework.zip",
                  checksum: "bd69c343d0ce586abe2185a859bac81eebd6b8c19c5320a49e559d91984e9e40")
  ]
)
