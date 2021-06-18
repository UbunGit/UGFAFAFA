#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np

def log(msg):
    pass

class Store:

    def __init__(self):
  
        self.cash_sum = 0 # 投入总金额
        self.count = 0  # 持仓
        self.cash = 0   # 逐笔资产结余
        self.zone = None    #
        self.blist = [] # 买入记录
        self.slist = [] # 卖出记录
        self.zones = [] # 持仓记录
        self.log = log

    def buy(self,date,count,price,free = 0):
        if np.isnan(price):
            self.log("买入失败：price is nan")
            return False
        if count==0:
            self.log("买入数量为0")
            return False
        # 购买
        if self.count == 0:
            self.cash = (count*price)+free
            self.count = count
            self.zone = {"begin":date, "end":None,"earnings":0,"earnings_v":0}
            self.zones.append(self.zone)
        else:
            self.cash = self.cash+(count*price)+ free
            self.count = self.count+count
        self.cash_sum = self.cash_sum +(count*price)+ free
        self.blist.append(
            {
                "bdate":date,
                "bcount":count,
                "bprice":price,
                "bfree":free
            }
        )
    
    def seller(self,date, price, count = None, free=0):
        if None == count:
            count = self.count
        
        if self.count == 0:
            self.log("卖出失败：没有持仓")
            return False
            
        if count<=0:
            self.log("卖出失败：卖出count<=0 count:{}".format(count))
            return False
        if count > self.count:
            self.log("卖出失败：持仓不足 卖出:{} 持仓：{}".format(count,self.count))
            return False
        if np.isnan(price):
            self.log("卖出失败：price is nan")
            return False
        
        self.slist.append(
            {
                "sdate":date,
                "scount":count,
                "sprice":price,
                "sfree":free
            }
        )
        self.cash = self.cash - free - (count*price)
        self.count = self.count - count
        if self.count == 0:
            self.zone["end"]= date
            self.zone["earnings"] = -self.cash
            self.zone["earnings_v"] = -self.cash/self.cash_sum
            self.zone = None
            self.cash_sum = 0
            self.cash = 0
        return True


if __name__ == "__main__":           
            
    store = Store()      
    store.buy(date="20210101",count=100,price=1.0)
    store.buy(date="20210102",count=100,price=1.5) 
    store.seller(date="20210103",count=100,price=2.0)            
    store.seller(date="20210104",count=100,price=1.0) 

    store.buy(date="20210105",count=100,price=1.0)
    store.buy(date="20210106",count=100,price=1.5) 
    store.seller(date="20210107",count=100,price=2.0)            
    store.seller(date="20210108",count=100,price=1.0) 

    store.buy(date="20210109",count=100,price=1.0)
    store.buy(date="20210110",count=100,price=1.5) 
    store.seller(date="20210111",count=100,price=2.0)            
    store.seller(date="20210112",count=100,price=1.0) 
    print(store.blist)
    print(store.slist)
    print(store.zones)