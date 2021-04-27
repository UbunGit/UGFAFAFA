import XCTest
@testable import SAnalyse

final class SAnalyseTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SAnalyse().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
