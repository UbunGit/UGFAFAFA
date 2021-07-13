import os,sys
import logging
sys.path.append('../code')

import unittest
from Tusharedata import db
from Tusharedata import base

tindex = 1
class Test(unittest.TestCase):
    @unittest.skipIf((tindex!=0 and tindex!=1),"reason")
    def test_db_StockBasic_inster(self):
        try:
            datas = base.search()
            db.StockBasic().createorupdate(datas)
            data = db.StockBasic().last(column="changeTime")
            db.session.rollback()
        except Exception as e:
            print(e)
        finally:
            db.session.close()

        print(data)

    @unittest.skipIf((tindex!=0 and tindex!=2),"reason")
    def test_db_StockBasic_last(self):
        data = db.StockBasic().last(column="changeTime")
        print(data)

if __name__ == "__main__":
    unittest.main()