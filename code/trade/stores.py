
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys


import logging
import pandas as pd
import numpy as np

from .moden import StoreData  
from .moden import ShareData

# 持仓

class Stores:

    balance = 0.00  # 余额
    assets = 0   #持股数量
    line = []
    online = []

    def __init__(self,money=2000, buyType=0, count=1):
     
        self.buyType = buyType # 0->按金额买入 1->按手买入
        self.money = money # 按金额买入标准
        self.count = count # 按手买入买入标准
      

    def buy(self,share,inScale=0.95):
        price = share.low
        if len(self.online)>0:
            price = self.minPrice()*inScale

        buyCount = self.buyCount(price)
        totalPrice =  price*buyCount

        if price<share.low:
            logging.debug('''时间{} 买入失败 买入价{:.3f} 最低价{} 比例{} online{}'''.format(share.date,price,share.low,inScale,len(self.online)))
            return

        if self.balance > totalPrice:
            store = StoreData()
            store.id = len(self.line)
            store.num = buyCount
            store.bdate = share.date
            store.bprice = price
            store.inday = 0
            self.balance = self.balance-totalPrice
            self.line.append(store)
            self.online.append(store)
            self.assets = self.assets+buyCount
            logging.debug("买入 价格{0} 数量：{1}".format(price,buyCount))
        else:
            logging.debug("余额不足:{}".format(self.balance))
            
    
    def seller(self,share,outScale=1.10, fee = 10.00):

        for item in self.online:
            item.inday = item.inday+1
            sellerPrice = item.bprice * outScale
            if sellerPrice < share.high:
                item.sdate = share.date
                item.sprice = sellerPrice
                item.isSeller = True
                item.fee = fee
                self.balance = self.balance+sellerPrice*item.num - fee
                self.assets = self.assets-item.num
                self.online.remove(item)
                logging.debug("卖出 id{} 价格：{}".format(item.id,item.sprice))
            else:
                logging.debug("卖出失败 id{}".format(item.id))

 
    def buyCount(self,price):
        if self.buyType == 0:
            return int(self.money/(price*100))*100

    def minPrice(self):
        list = []
        for item in self.online:
            list.append(item.bprice)
        return min(list)


import unittest
logging.basicConfig(level=logging.NOTSET)  # 设置日志级别
class TestStores(unittest.TestCase):

    def setUp(self):

        self.stores = Stores()
        self.stores.balance = 10000

    def test_stores_buyCount(self):
        num = self.stores.buyCount(2.001)
        logging.debug("持仓列表{}".format(len(self.stores.online)))

    def test_stores_buy(self):
        share = ShareData()
        share.date = "2020-01-01"
        share.low = 1.001
        share.height = 2.001
        self.stores.buy(share, inScale = 0.95)

        share.date = "2020-01-02"
        share.low = 2.001
        share.height = 3.001
        self.stores.seller(share, outScale= 1.10)
        logging.debug("余额：{}".format(self.stores.balance))
        logging.debug("持股：{}".format(self.stores.assets))
        res = pd.DataFrame(map(lambda x:x.__dict__,self.stores.line), columns=('num', 'bdate', 'sdate', 'bprice', 'sprice', 'isSeller', 'inday', 'fee'), index=map(lambda x:x.id,self.stores.line))
        print(res.head())


if __name__ == '__main__':
    unittest.main()


    
