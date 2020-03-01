import tushare as ts
import logging
import talib as tl
import numpy


class trade:
    data = None # 股票数据
    balance = 0  # 余额
    store = 0   #持股数量
    lastTime = None #最后交易时间
    def __init__(self, code, begin=None, end= None, balance=1000):
        self.balance = balance
        self.data =  ts.get_k_data(code=code) #一次性获取全部日k线数据

    def buy(self, price, time, count=100):
        if price <= 0:
            return False,'price not allow zero'
        if time is None:
            return False,'time not allow None'
        if count <=0:
            return False ,'count not allow zero'

        t_money = price*count
        if(self.balance-t_money<0):
            return False ,'balance is not enough. '
        self.balance -= t_money
        self.store += count
        self.lastTime = time
        return True,'OK '
    
    def sell(self, price, time, count=None):
      
        if price <= 0:
            return False, 'time is zero. ' 
        if time is None:
            return False, 'time is None. ' 
        if self.store<=0:
            return False, 'store is zero. ' 
        if count <=0:
            count = self.store
        if count>self.store:
            return False, 'store is not enough. ' 

        self.balance += price*count
        self.store -= count
        self.lastTime = time
        return True,'OK '
      
