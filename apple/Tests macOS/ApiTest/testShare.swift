//
//  testShare.swift
//  Tests macOS
//
//  Created by admin on 2021/3/30.
//

import XCTest

class testShare: XCTestCase {
    override class func setUp() {
        UserDefaults.standard.setValue("/Users/admin/Documents/github/UGFAFAFA/data/", forKey: "dbfile")
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShareList() throws {
 
        
    }
    
    func testdetail()  {
   
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
