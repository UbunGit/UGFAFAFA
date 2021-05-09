    import XCTest
    import PythonKit
    
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
        
        func test_damrey() {
            let py_sys = Python.import("sys")
            py_sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code/")
            let anglyse = Python.import("Analyse.damrey")
            let df = anglyse.catchdata("000001.SZ")
            
            let kline = Python.import("chart.kline")
            let webpath = kline.kline(df).render("./result.html")
            print("\(webpath)")
        }
    }
    
    
