import XCTest


@testable import UGAnalyse

final class PyRequestTests: XCTestCase,PyRequest {
    
    
    func test_backtrading() {

        let code = "002028.SZ"
        let begin = "20200513"
        let end = "20210513"
        let analyse = "damrey"
        
        backtrading(analyse:analyse,
                    code:code,
                    begin:begin,
                    end:end){ result in
            switch result{
            case .failure(let erroe):
                print("error: \(erroe)")
            case .success(let pyobj):
                print("\(pyobj)")
                XCTAssert(true)
            }
            
        }
        
        waitForExpectations(timeout: 59) { erroe in
            print("timt out \(erroe)")
        }
        
    }
    
    
}
