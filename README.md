# MAVSDK-XCFramework

Swift Package distribution of the pre-compiled mavsdk_server.xcframework found in [MAVSDK Releases](https://github.com/mavlink/MAVSDK/releases)

## Installation

### Swift Package Manager

#### Limitations

- Requires Xcode 12.0+ to import Swift 5.3.
- mavsdk_server.xcframework is currently only supported on iOS and MacOS.

#### `Package.swift` Manifest
```
// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "MavsdkTestProject",
  dependencies: [
    .package(url: "https://github.com/mavlink/MAVSDK-XCFramework", .exact("0.37.0"))
  ],
  targets: [
    .target(name: "MavsdkServer",
      dependencies: [
        .product(name: "mavsdk_server",
                 package: "MAVSDK-XCFramework",
                 condition: .when(platforms: [.iOS, .macOS]))
      ]
    )
  ]
)
```

## Contributing

Directions to generate the mavsdk_server.xcframework can be found [here](https://mavsdk.mavlink.io/develop/en/contributing/build.html)

### Setup

1. Install [Xcode](https://developer.apple.com/xcode/)

2. Install CMake with [HomeBrew](https://brew.sh/)
```
$ brew install cmake
```

3. Setup Python environment and dependencies (the first two commands are optional but recommended.)
```
$ python3 -m venv venv
$ source venv/bin/activate

$ pip3 install protoc-gen-mavsdk
```

### Building `mavsdk_server.xcframework`

1. Clone MAVSDK core repository:

SSH:
```
$ git clone git@github.com:mavlink/MAVSDK.git
$ cd MAVSDK
```

HTTPS:
```
$ git clone https://github.com/mavlink/MAVSDK.git
$ cd MAVSDK
```

2.  Initialize submodules

```git
$ git submodule --init --recursive
```

3. Build `mavsdk_server.framework` per platform (based on the [MAVSDK GitHub CI/CD workflows](https://github.com/mavlink/MAVSDK/blob/develop/.github/workflows/main.yml))

**macOS**
```
$ cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_MAVSDK_SERVER=ON -Bbuild/default -H.
$ cmake --build build/default
```

**iOS**
```
$ export SDKROOT=$(xcrun --sdk iphoneos --show-sdk-path)

$ cmake -DENABLE_STRICT_TRY_COMPILE=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=$(pwd)/tools/ios.toolchain.cmake -DPLATFORM=OS -DDEPLOYMENT_TARGET=11.0 -DBUILD_MAVSDK_SERVER=ON -DBUILD_SHARED_LIBS=OFF -DWERROR=OFF -j 2 -Bbuild/ios -H.

$ cmake --build build/ios -j 2
```

**iOS simulator**
```
$ export SDKROOT=$(xcrun --sdk iphonesimulator --show-sdk-path)

$ $ cmake -DENABLE_STRICT_TRY_COMPILE=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=$(pwd)/tools/ios.toolchain.cmake -DPLATFORM=SIMULATOR64 -DDEPLOYMENT_TARGET=11.0 -DBUILD_MAVSDK_SERVER=ON -DBUILD_SHARED_LIBS=OFF -DWERROR=OFF -Bbuild/ios_simulator -H.

$ cmake --build build/ios_simulator -j 2
```

4. Package each `mavsdk_server.framework` binary into a single multi-platform `mavsdk_server.xcframework`

```
bash src/mavsdk_server/tools/package_mavsdk_server_framework.bash
```

5. The `mavsdk_server.xcframework` output can now be found in `/build`. Drag-and-drop the 

### Extending `MAVSDK`

Watch [this video](https://www.youtube.com/watch?v=T1orxSyqDzI) on how to extend fesatures in `MAVSDK`.

### Testing `MAVSDK-XCFramework`

Use these steps to test updates `mavsdk_server.xcframework` when sourcing the  `MAVSDK-XCFramework` Swift Package locally.

1. Open the `MAVSDK-XCFramework` directory in Finder and then drag-and-drop it into */Sources/MAVSDK-XCFramework*.

2. Adjust the `Package.swift` manifest file in `MAVSDK-XCFramework` to reference the new local `mavsdk_server.xcframework`.

```
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
    .binaryTarget(name: "mavsdk_server,
                  path: "Sources/MAVSDK-XCFramework")
  ]
)
```

3. Source the new `MAVSDK-XCFramework` Package into your existing project. If not already using a local Swift Package, open the `MAVSDK-XCFramework` directory in Finder and then drag-and-drop it into your existing Xcode Project. You can now use the local `MAVSDK-XCFramework` Swift Package  in two different ways:

**Local Swift Package**

```
// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "MavsdkExample",
  products: [
    .library(name: "MavsdkServerExample",
             targets: [
               "MavsdkServerExample"
             ]
    )
  ],
  dependencies: [
    .package(url: "../path/to/MAVSDK-XCFramework", .branch("main"))
  ],
  targets: [
    .target(name: "MavsdkServerExample",
            dependencies: [
              .product(name: "mavsdk_server",
                       package: "MAVSDK-XCFramework",
                       condition: .when(platforms: [.iOS, .macOS]))
            ]
    )
  ]
)
```

**Local .xcodeproj**

Within Xcode, select the .xcodeproj at the top of the Project navigator, select your Target, and add the library in `Frameworks, Libraries, and Embedded Content`

### Publishing `MAVSDK-XCFramework`

1. Compute a checksum to verify remote package contents.

```
$ swift package compute-checksum mavsdk_server.xcframework.zip
6d988a1a27418674b4d7c31732f6d60e60734ceb11a0ceb11a0ce9b54d1871918d9c194
```

2. Host the downloadable `mavsdk_framework.xcframework.zip` at a specific URL (such as an Amazon S3 Storage Bucket.)

3. Update `Package.swift` manifest to reference the new binary.

```
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
                  url: "https://myurl.com/path/to/mavsdk_server.xcframework.zip",
                  checksum: "6d988a1a27418674b4d7c31732f6d60e60734ceb11a0ceb11a0ce9b54d1871918d9c194")
    ]
)
```

4. Commit the new `Package.swift` to a GitHub repositiory.

5.  Use the new custom `MAVSDK-XCFramework` binary package (usage details [above](#Installation)) in your project.
