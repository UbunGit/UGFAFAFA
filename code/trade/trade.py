import tushare as ts
import logging
import talib as tl
import numpy


class trade:

    balance = 0.00  # 余额
    store = 0   #持股数量

    def __init__(self,balance=10000.00):
        logging.info("trade begin 初始化交易系统.")
        self.balance = float(balance)
        self.store = 0
        logging.info("trade end 交易系统初始化成功.")

    def buy(self, price, count=100):
        logging.info("begin buy")
        if price <= 0:
            raise Exception("price not allow zero.")
        if count <=0:
            raise Exception("count not allow zero.")
        t_money = price*count
        if(float(self.balance) < float(t_money)):
            raise Exception("balance is not enough.")
        self.balance -= t_money
        self.store += count
        logging.info("end buy 余额：%s 持仓%s",self.balance,self.store)

        
  
    
    def sell(self, price, count=None):
        logging.info("begin sell")
        if price <= 0:
            raise Exception("price not allow zero.")
        if count <=0:
            raise Exception("count not allow zero.")
        if self.store<=0:
            raise Exception("store is zero.")
        if count>self.store:
            raise Exception("store is not enough. .")

        self.balance += price*count
        self.store -= count
        logging.info("end sell 余额：%s 持仓%s",self.balance,self.store)

    
if __name__ == '__main__':
    trade = trade()
    trade.buy(10,100)
    trade.sell(15,100)

   
