import XCTest
@testable import MAVSDK_XCFramework

final class MAVSDK_XCFrameworkTests: XCTestCase {
    func testExample() {
        XCTAssertEqual(MAVSDK_XCFramework().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
