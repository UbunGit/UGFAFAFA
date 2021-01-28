#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import logging

class Stores:

    def __init__(self, balance=2000):

        self.balance = balance
        self.assets = 0   #持股数量
        self.nextId = 0
        self.online = []
        self.line = []
        logging.info(
            '''
            初始化Stores
            余额balance：{}
            持股assets：{}
            持仓online：{}
            记录line：{}
            '''
            .format(self.balance,self.assets,self.online,self.line)
        )
        

    def buy(self, store):
        store["id"] = self.next()
        
        self.balance = self.balance - store.get('num')*store.get("bprice")
        self.online.append(store)
        self.line.append(store)
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


    
