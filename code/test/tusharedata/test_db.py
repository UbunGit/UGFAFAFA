from datetime import datetime
import os,sys
import logging

sys.path.append('../code')

import unittest
from Tusharedata import db
from Tusharedata import base
from config import dataPath as root

tindex = 100
class Test(unittest.TestCase):

    @unittest.skipIf((tindex!=0 and tindex!=1),"reason")
    def test_db_StockBasic_inster(self):
        try:
            datas = base.search()
            db.StockBasic().createorupdate(datas)
            data = db.StockBasic().last(column="changeTime")
        except Exception as e:
            print(e)
        finally:
            db.session.close()

        print(data)


    @unittest.skipIf((tindex!=0 and tindex!=2),"reason")
    def test_db_StockBasic_fitter(self):
        data = db.StockBasic().fitter(keyword="200", changeTime="20210101")
        print(data)

    @unittest.skipIf((tindex!=0 and tindex!=3),"reason")
    def test_db_StockBasic_last(self):
        data = db.StockBasic().last(column="changeTime")
        print(data)

    
    @unittest.skipIf((tindex!=0 and tindex!=100),"reason")
    def test_db_ETFBase_fitter(self):
        data = db.ETFBasic().fitter(changeTime="20210701")
        print(data)

if __name__ == "__main__":
    unittest.main()