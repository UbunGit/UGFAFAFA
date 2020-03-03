import tushare as ts
import logging
import talib as tl
import numpy


class trade:
    data = None # 股票数据
    balance = 0.00  # 余额
    store = 0   #持股数量
    lastTime = None #最后交易时间

    def __init__(self, code, begin = '', end= '', balance=10000.00):
        self.balance = float(balance)
 
        if begin is None:
            begin = None
        if begin == 'None' or begin == 'null' or begin == '':
            begin = None
        if end is None :
            end = None
        if end == 'None' or end == 'null' or end == '':
            end = None

        self.data =  ts.get_hist_data(code=code,start=begin,end=end) #一次性获取全部日k线数据
        self.data.sort_index(inplace=True)

    def buy(self, price, time, count=100):
        if price <= 0:
            return False,'price not allow zero',0
        if time is None:
            return False,'time not allow None',0
        if count <=0:
            return False ,'count not allow zero',0

        t_money = price*count

        if(float(self.balance) < float(t_money)):
            return False ,'balance is not enough. ',0
        self.balance -= t_money
        self.store += count
        self.lastTime = time
        return True,'OK ',count
    
    def sell(self, price, time, count=None):
      
        if price <= 0:
            return False, 'time is zero. ' ,0
        if time is None:
            return False, 'time is None. ' ,0
        if self.store<=0:
            return False, 'store is zero. ' ,0
        if count <=0:
            count = self.store
        if count>self.store:
            return False, 'store is not enough. ' ,0

        self.balance += price*count
        self.store -= count
        self.lastTime = time
        return True,'OK ',count
    
      
