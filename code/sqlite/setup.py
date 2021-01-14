#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sqlite3
import os

from config import path
from trade import trade_create

def isExistsdb():
    # 判断数据库是否存在
    return  os.path.exists(path)

def createDb():
    # 初始化sqlite
    trade_create(path)
    return 0

# ######################################
import unittest
class setup(unittest.TestCase):

    def test_isExistsdb(self):
        self.assertEqual(isExistsdb(), True)

    def test_createDb(self):
        createDb()
        self.assertEqual(isExistsdb(), True)

if __name__ == '__main__':
    unittest.main()