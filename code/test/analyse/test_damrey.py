#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os,sys
import logging
sys.path.append('/Users/admin/Documents/GitHub/UGFAFAFA/code')

import unittest
import Analyse.damrey as damrey
import Analyse.back_trading as back_trading
import chart.kline as kline



tindex = 3
class Test(unittest.TestCase):

    @unittest.skipIf((tindex!=0 and tindex!=1),"reason")
    def test_damrey_analyse(self):
        df = damrey.analyse(code="002028.SZ", param='{"ma":"30","rankDay":"3"}')



    @unittest.skipIf((tindex!=0 and tindex!=2),"reason")
    def test_damrey_catchdata(self):
        df = damrey.catchdata(code="002028.SZ")
        df = back_trading(df,begin="20210512",end="20210512")
        kline.kline(df).render("/Users/admin/Documents/github/UGFAFAFA/data/tem/testanalyse.html")
        df = df[["date","assets","sdate","signal","count"]]
        df.to_csv("/Users/admin/Documents/github/UGFAFAFA/data/tem/test.csv")

if __name__ == "__main__":
    unittest.main()