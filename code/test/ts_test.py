import unittest
import tushare as ts

class Test(unittest.TestCase):

    print(ts.__version__)
    def test_guba_sina(self):
        df = ts.guba_sina(show_content=True)
        print(df)
        
if __name__ == "__main__":
    unittest.main()

