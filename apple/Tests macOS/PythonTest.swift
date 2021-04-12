//
//  PythonTest.swift
//  Tests macOS
//
//  Created by admin on 2021/4/9.
//

import XCTest
import PythonKit


class PythonTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_PythonKit() throws {
        
        do {
            let sys = Python.import("sys")
            print("Python \(sys.version_info.major).\(sys.version_info.minor)")
            print("Python Version: \(sys.version)")
            print("Python Encoding: \(sys.getdefaultencoding().upper())")
   
            sys.path.append("/Users/admin/Documents/GitHub/UGFAFAFA/code")
            let trade = Python.import("trade")
            let tf = trade.share(code:"600111.SH",begin:"20210101", end:"20210301")
            print("tf: \(tf.cdata.count)")
            print("tf: \(tf.cdata)")

        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
 
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    

}
