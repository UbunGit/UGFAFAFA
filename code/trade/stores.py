#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys

import logging
import pandas as pd
import numpy as np

from .moden import StoreData  
from .moden import ShareData

class Stores:
    # 持仓
    balance = 0.00  # 余额
    assets = 0   #持股数量
    line = []
    online = []

    def __init__(self, money=2000, buyType=0, count=1):
     
        self.buyType = buyType 
        self.money = money
        self.count = count 

    def buy(self, store):

        self.balance = self.balance - store.num*store.bprice
        self.line.append(store)
        self.online.append(store)
        self.assets = self.assets+store.num
        logging.debug("买入 价格{0} 数量：{1}".format(store.bprice,store.num))

    def seller(self,store):

        self.balance = self.balance+store.sprice*store.num - store.fee
        self.assets = self.assets-store.num
        self.online.remove(store)
        logging.debug("卖出 id{} 价格：{}".format(store.id,store.sprice))
         


import unittest

class TestStores(unittest.TestCase):

    def setUp(self):

        self.stores = Stores()
        self.stores.balance = 10000


if __name__ == '__main__':
    unittest.main()


    
