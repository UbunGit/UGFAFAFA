    import XCTest
    import Foundation
    import PerfectSQLite
    import PerfectCRUD
    
    
    @testable import UGAnalyse

    final class InfoCacheTest: XCTestCase {
        let t_key = "testdata"
        let t_value = "000000"
        let t_value1 = "11111"

        func test_insert() {
            UGAnalyse.setup()
            do{
                // 0 设置测试数据
                try DataCache.setvalue(t_value, for: t_key)
                var value = try DataCache.value(of: t_key)
                if value != t_value {
                    throw BaseError(code: 100, msg:"error: 0 设置测试数据")
                }
                // 1 修改测试数据
                try DataCache.setvalue(t_value1, for: t_key)
                value = try DataCache.value(of: "testdata")
                if value != t_value1 {
                    throw BaseError(code: 100, msg:"error: 1 修改测试数据")
                }
                // 2 删除测试数据
                try DataCache.remove(t_key)
                value = try DataCache.value(of: t_key)
                if value != nil {
                    throw BaseError(code: 100, msg:"error: 2 删除测试数据")
                }
                XCTAssert(true)
            }catch{
                XCTAssert(false, "error:\(error)")
            }
        }
    }
