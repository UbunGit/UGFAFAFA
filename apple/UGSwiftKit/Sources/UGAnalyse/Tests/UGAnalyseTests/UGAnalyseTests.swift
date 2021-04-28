    import XCTest
    
    @testable import UGAnalyse

    final class UGAnalyseTests: XCTestCase {
        func testExample() {
        
            do{
                UGAnalyse.setup()
                let data = try UGAnalyse.stockBasic()
                print("\(data.head())")
                XCTAssert(true)
            }catch{
                XCTAssert(false, "error:\(error)")
            }
        }
        
        func test_needDownload() {
                let key = "UGAnalyse.stockBasic.test"
            do{
                UGAnalyse.setup()
                
                try DataCache.setvalue("2021-04-28 16:10:23", for: key)
                var isneed = UGAnalyse.needDownload(key)
                if isneed {
                    throw BaseError(code: 100, msg: "🐛 1 needDownload result error")
                }
                try DataCache.setvalue("2021-04-28 11:10:23", for: key)
                isneed = UGAnalyse.needDownload(key)
                if isneed  {
                    throw BaseError(code: 100, msg: "🐛2 needDownload result error")
                }
                try DataCache.setvalue("2021-04-27 11:10:23", for: key)
                isneed = UGAnalyse.needDownload(key)
                if isneed == false {
                    throw BaseError(code: 100, msg: "🐛3 needDownload result error")
                }
                try DataCache.remove(key)
                XCTAssert(true)
            }catch{
                XCTAssert(false, "error:\(error)")
            }
        }
    }
