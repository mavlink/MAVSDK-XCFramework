import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MAVSDK_XCFrameworkTests.allTests),
    ]
}
#endif
