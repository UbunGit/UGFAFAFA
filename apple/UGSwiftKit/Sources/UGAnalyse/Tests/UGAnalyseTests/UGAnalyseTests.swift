    import XCTest
    
    @testable import UGAnalyse

    final class UGAnalyseTests: XCTestCase {
        func testExample() {
            do{
                UGAnalyse.setup()
                try UGAnalyse.stockBasic()
                XCTAssert(true)
            }catch{
                XCTAssert(false, "error:\(error)")
            }
        }
    }
