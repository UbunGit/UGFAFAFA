
import PythonKit

public let py_sys = Python.import("sys")
public let py_os =  Python.import("os")
public let py_pd = Python.import("pandas")

public struct SAnalyse {
    
    var text = "Hello, World!"

}

extension SAnalyse{
    
    public static func setup(locallib:String = "/Users/admin/Documents/github/UGFAFAFA/code"){
        print("SAnalyse setup")
        py_sys.path.append(locallib)
        print("\(py_sys.path)")
    }
}


