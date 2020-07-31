import unittest
import tushare as ts
ts.set_token("8631d6ca5dccdcd4b9e0eed7286611e40507c7eba04649c0eee71195")
class Test(unittest.TestCase):

    print(ts.__version__)
    @unittest.skip("跳过该测试项") 
    def test_guba_sina(self):
        df = ts.guba_sina(show_content=True)
        print(df)
    
    def test_pro_bar(self):
        df = ts.pro_bar(ts_code='000001.SZ', adj='qfq')
        print(df)

    

        
if __name__ == "__main__":
    unittest.main()

