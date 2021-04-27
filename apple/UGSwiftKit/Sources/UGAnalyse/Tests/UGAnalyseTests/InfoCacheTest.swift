    import XCTest
    
    @testable import UGAnalyse

    final class InfoCacheTest: XCTestCase {
        func testExample() {
            do{
                UGAnalyse.setup()
                try InfoCache.save(key:"test",value:"20202020")
                XCTAssert(true)
            }catch{
                XCTAssert(false, "error:\(error)")
            }
        }
    }
