#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os,sys
import logging
sys.path.append('/Users/admin/Documents/GitHub/UGFAFAFA/code')

import unittest
import Analyse.damrey as damrey
import chart.kline as kline
tindex = 0
class Test(unittest.TestCase):

    @unittest.skipIf((tindex!=0 and tindex!=1),"reason")
    def test_damrey_analyse(self):
        damrey.analyse(code="000001.SZ", param='{"ma2":"5","ma1":"30"}')

    @unittest.skipIf((tindex!=0 and tindex!=2),"reason")
    def test_damrey_catchdata(self):
        df = damrey.catchdata(code="000001.SZ")
        kline.kline(df).render("/Users/admin/Documents/github/UGFAFAFA/data/tem/resultrateView.html")

if __name__ == "__main__":
    unittest.main()