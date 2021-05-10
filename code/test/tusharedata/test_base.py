#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os,sys
import logging

sys.path.append('/Users/admin/Documents/GitHub/UGFAFAFA/code')

import unittest
import Tusharedata.base as base

tindex = 3
class Test(unittest.TestCase):

    @unittest.skipIf((tindex!=0 and tindex!=1),"reason")
    def test_base(self):
        time = base.updateTime()
        print(time)

    @unittest.skipIf((tindex!=0 and tindex!=2),"reason")
    def test_reload(self):
        data = base.reload()
        print(data)

    @unittest.skipIf((tindex!=0 and tindex!=3),"reason")
    def test_reload(self):
        data = base.search("思")
        print(data)

   

if __name__ == "__main__":
    unittest.main()