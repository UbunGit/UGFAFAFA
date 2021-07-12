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
    
    func testCerebro_onebs()  {
        let cerebro = Cerebro()
        _  = cerebro.buy(code: "00001", date: Date.init().addingTimeInterval(-60*24*60*60), price: 1.00, count: 100) { money in
            (money*0.003)+5
        }
        let min = cerebro.minimumbs(code: "00001")
        cerebro.seller(code: min!.code, price: 1.1, date: Date.init()) {
            ($0*0.003)+5
        }
        print(cerebro.cash)
    }
    
    func testCerebro_ma()  {
        let ma = lib_ma(5, closes: [1,2,3,4,5,6,7,8,9,10])
        print(ma)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
