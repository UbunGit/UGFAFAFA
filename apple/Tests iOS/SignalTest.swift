//
//  SignalTest.swift
//  Tests iOS
//
//  Created by admin on 2021/7/9.
//

import XCTest
import apple

class SignalTest: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testCerebro_Loging() throws {
        Cerebro().loging("eeee")
        XCTAssert(true, "====")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
