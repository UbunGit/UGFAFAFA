    import XCTest
    
    @testable import UGAnalyse

    final class UGAnalyseTests: XCTestCase {
        func testExample() {
            let analyse  = UGAnalyse()
            analyse.plot.name = "maline"
            try? analyse.plotInfo()
            try? analyse.plotparam()
            print(analyse.plot)
        }
        
        func test_needDownload() {
            
        }
    }
