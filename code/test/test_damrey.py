#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os,sys
import logging
sys.path.append('/Users/admin/Documents/GitHub/UGFAFAFA/code')

import unittest
import Analyse.damrey as damrey

class Test(unittest.TestCase):
    def test_pro_bar(self):
        damrey.analyse(code="000001.SZ", param='{"ma2":"5","ma1":"30"}')

if __name__ == "__main__":
    unittest.main()