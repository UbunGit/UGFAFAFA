import XCTest

@testable import UGAnalyse

final class BarTests: XCTestCase {
    
    func test_bar() {
    
        do{
            let html = Bar.bar()
            print(html)
            XCTAssert(true)
        }catch{
            XCTAssert(false, "error:\(error)")
        }
    }
    

}
