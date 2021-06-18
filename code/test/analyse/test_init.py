
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os,sys
import logging

sys.path.append('/Users/admin/Documents/GitHub/UGFAFAFA/code')

import unittest
from Analyse import Analyse

tindex = 1
class Test(unittest.TestCase):

    @unittest.skipIf((tindex!=0 and tindex!=1), "reason")
    def test_Analyse(self):  
        analyse = Analyse()
        analyse.setup()
        analyse.catch()

if __name__ == "__main__":
    unittest.main()