//
//  Test_ML.swift
//  Tests macOS
//
//  Created by admin on 2021/4/11.
//

import XCTest
import CreateML

class Test_ML: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let mode =  ML_Ma()
        for td in [1:20]{
            let re = try mode.prediction(text: 1).lable
            print(re)
        }
      
        
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
