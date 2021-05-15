#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import pandas as pd

class Cerebro:
    '''
    回测中心
    '''

    def __init__(self):

        def bcomm(amount):
            return 0
        def scomm(amount):
            return 0

        
        self.bcomm = bcomm  #买入手续费计算公式
        self.scomm = scomm  #买入手续费计算公式
    
        self.cash = 10000 # 初始金额
        self.strategy = None # 策略
        self.data = list() # 股票列表 pa.DataForm

        self.position = 0 #持仓
        self.orders = list()
      
    def run(self):
        def runapply(data):
            # print(data.date)
            order = {}
            order["bcomm"] = 0
            order["scomm"] = 0
            order["berror"] = None
            order["serror"] = None
            order["bcount"], order["bprice"], order["scount"], order["sprice"] = self.strategy.next(data)
            # 卖出逻辑
            if(order["scount"]*order["sprice"]):
                amount = order["scount"]*order["sprice"]
                free = self.scomm(amount)
                if self.position > order["scount"]:
                    self.cash = self.cash + (amount - free)
                    self.position = self.position - order["scount"]
                else:
                    order["serror"] = "持仓不足"
                    # 持仓不足
                    order["scount"] = 0
                    order["sprice"] = 0
                    order["scomm"] = 0

                order["scomm"] = self.scomm(order["scount"]*order["sprice"])
            # 买入逻辑

            if(order["bcount"]*order["bprice"]):
                amount = order["bcount"]*order["bprice"]
                free = self.bcomm(amount)
                if(self.cash - amount - free)<=0:
                    # 余额不足
                    order["berror"] = "余额不足"
                    order["bcount"] = 0
                    order["bprice"] = 0
                    order["bcomm"] = 0
                else:
                    order["bcomm"] = free
                    self.cash = self.cash - amount - free
                    self.position = self.position + order["bcount"]
            print(order)
            order["cash"] = self.cash
            order["position"] = self.position
            return order

        df = pd.DataFrame()
        arr = self.data.apply(runapply, axis=1)
        df = pd.DataFrame(arr.values.tolist())
        df.index= pd.to_datetime(arr.index)
        return df
        
import unittest
tindex = 1

class Test(unittest.TestCase):
    import sys
    
    sys.path.append('/Users/admin/Documents/GitHub/UGFAFAFA/code')

    @unittest.skipIf((tindex!=0 and tindex!=1), "reason")
    def test_base(self):
        print("begin test")
        from Tusharedata.daily import load as loaddata
        from strategy import Strategy


        cerebro = Cerebro()
        df = loaddata(code="300059.SZ")
        df = df[df["date"]>"20200101"]
        df.index=pd.to_datetime(df.date)
        cerebro.data = df
        cerebro.strategy = Strategy()

        def bcomm(amount):
            return amount*0.003
        cerebro.bcomm = bcomm
        cerebro.run()
if __name__ == "__main__":
    unittest.main()
    