#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import pandas as pd

class Cerebro:
    '''
    回测中心
    '''

    def __init__(self):

        def bcomm(amount):
            yongjin = 5 if amount*0.003<5 else amount*0.003
            yinhua = 0
            guohu = amount*0.0006
            return yongjin+yinhua+guohu
        def scomm(amount):
            yongjin = 5 if amount*0.003<5 else amount*0.003
            yinhua =  amount*0.001
            return yongjin+yinhua
            return 0
        def strategy(data,cerebro):
            return 0,0,0,0
        def log(msg):
            pass

        self.bcomm = bcomm  #买入手续费计算公式
        self.scomm = scomm  #买入手续费计算公式
        self.strategy = strategy # 策略
        self.cash = 10000 # 初始金额
        self.log = log
        
        self.data = list() # 股票列表 pa.DataForm

        self.position = 0 #持仓
        self.orders = list()
      
    def run(self):
        def runapply(data,cerebro):
          
            order = {}
            order["bcomm"] = 0
            order["scomm"] = 0
            order["berror"] = None
            order["serror"] = None
            order["bcount"], order["bprice"], order["scount"], order["sprice"] = self.strategy(data,cerebro)

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
            order["cash"] = self.cash
            order["position"] = self.position
            self.log(order)
            return order

        df = pd.DataFrame()
        orders = self.data.apply(runapply, axis=1,args=(self,))
        df = pd.DataFrame(orders.values.tolist())
        df.index= pd.to_datetime(orders.index)
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
      


        cerebro = Cerebro()
        df = loaddata(code="300059.SZ")
        df = df[df["date"]>"20200101"]
        df.index=pd.to_datetime(df.date)
        cerebro.data = df
        # cerebro.strategy = Strategy()

        def bcomm(amount):
            return amount*0.003
        cerebro.bcomm = bcomm
        cerebro.run()
if __name__ == "__main__":
    unittest.main()
    