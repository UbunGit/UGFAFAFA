import XCTest

@testable import UGAnalyse

final class UGMAAnalyseTest: XCTestCase {
    
    func test_analyse() {
    
        do{
            UGAnalyse.setup()
            let data = try UGMAAnalyse.analyse()
            XCTAssert(true)
        }catch{
            XCTAssert(false, "error:\(error)")
        }
    }

}
