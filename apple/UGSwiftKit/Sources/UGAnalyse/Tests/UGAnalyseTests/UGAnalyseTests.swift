    import XCTest
    
    @testable import UGAnalyse

    final class UGAnalyseTests: XCTestCase {
        func testExample() {
            let analyse  = UGAnalyse()
            analyse.plot.name = "Maline"
            try? analyse.plotInfo()
            print(analyse.plot)
        }
        
        func test_needDownload() {
            
        }
    }
