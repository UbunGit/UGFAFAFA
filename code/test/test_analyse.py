#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os,sys
import logging
sys.path.append('./code')

import unittest
import Analyse.Maline as maline
class Test(unittest.TestCase):

    def test_pro_bar(self):
        print(maline.info())
        maline.analyse(code="000002.SZ", begin=None, end=None, param='{"ma2":"25","ma1":"8"}')

    

        
if __name__ == "__main__":
    unittest.main()