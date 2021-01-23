#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import logging



class Stores:
    # 持仓
    balance = 0.00  # 余额
    assets = 0   #持股数量
    online = []
    nextId = 0

    def __init__(self, money=2000, buyType=0, count=1):
     
        self.buyType = buyType 
        self.money = money
        self.count = count 

    def buy(self, store):

        self.balance = self.balance - store.get('num')*store.get("bprice")
        self.online.append(store)
        self.assets = self.assets+store.get('num')


    def seller(self,store):

        self.balance = self.balance+store.get("sprice")*store.get('num') - store.get("fee")
        self.assets = self.assets-store.get('num')
        self.online.remove(store)

    def minPrice(self):
        list = []
        for item in self.online:
            list.append(item.get("bprice"))
        return min(list)

    def next(self):
        self.nextId = self.nextId+1
        return self.nextId

import unittest

class TestStores(unittest.TestCase):

    def setUp(self):

        self.stores = Stores()
        self.stores.balance = 10000


if __name__ == '__main__':
    unittest.main()


    
