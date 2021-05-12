    import XCTest
    import PythonKit
    
    @testable import UGAnalyse

    final class UGAnalyseTests: XCTestCase {
        
        func testExample() {
 
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
        
        func test_AnalyseList_loaddata() {
            let py_sys = Python.import("sys")
            py_sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code/")
            let analyses = AnalyseList().loaddata()
        }
    }
    
    
