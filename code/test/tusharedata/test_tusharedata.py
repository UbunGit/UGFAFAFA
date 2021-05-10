#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os,sys
import logging
sys.path.append('./code')

import unittest
from Tusharedata import lib, loadDaily
class Test(unittest.TestCase):

    def test_pro_bar(self):
        data = loadDaily(code="000002.SZ")
        lib.rank(data,"close",2)

if __name__ == "__main__":
    unittest.main()