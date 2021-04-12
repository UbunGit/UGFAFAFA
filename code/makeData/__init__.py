from .make_offic import getdata,mapdata
from datetime import datetime
import logging
logging.basicConfig(level=logging.NOTSET)  # 设置日志级别
datapath = "./data/cvs"

import unittest

class TestStores(unittest.TestCase):

    def setUp(self):
        logging.info ("setup...")

    def test_getdata(self):
        logging.info("test_getdata.")
        try:
            code = "300022.sz"
            datas = getdata(code=code)
            logging.debug(". datas length is:%s .",len(datas))
            svdata = mapdata(datas)
            logging.debug(svdata.head())
            svdata.to_csv('./data/traindata/ma5-30_$code.csv')

            pltdata = svdata[30:300]
            logging.debug(pltdata)

            # pltdata["x"] = [datetime.strptime(d, '%Y%m%d') for d in pltdata['date']]

            # plt.title("Matplotlib demo") 
            # plt.xlabel("x date") 
            # plt.ylabel("y lable") 
            # plt.plot(pltdata["x"],pltdata["lable"]) 
            # plt.plot(pltdata["x"],pltdata["text"]) 
            # plt.show()
        except Exception as err:
            logging.error (err)
      
      
        


if __name__ == '__main__':
    unittest.main()