#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os,sys
import logging
sys.path.append('../code')

import unittest
from Tusharedata import lib, daily
class Test(unittest.TestCase):

    def test_pro_bar(self):
        data = daily.load(code="000002.SZ")
        print(data)

if __name__ == "__main__":
    unittest.main()