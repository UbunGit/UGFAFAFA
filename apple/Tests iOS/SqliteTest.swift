//
//  SqliteTest.swift
//  Tests iOS
//
//  Created by admin on 2021/7/5.
//
import apple
import XCTest
import SQLite
import UGSwiftKit

class Tests_Sqlite: XCTestCase {
    let dailys:[Daily] = []

    override func setUpWithError() throws {
       
    }

    override func tearDownWithError() throws {
        
    }

    func testExample() throws {
        print(Daily.sqliteFile)
        XCTFail("")
    }
    func test_daily_reqData()  {
        
      
    }
    
 

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
