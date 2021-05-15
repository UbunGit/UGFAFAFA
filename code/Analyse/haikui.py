#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 海葵策略
from __future__ import (absolute_import, division, print_function,
                        unicode_literals)
import sys,traceback
import os
import json, logging
import pandas as pd
import numpy as np

sys.path.append('/Users/admin/Documents/GitHub/UGFAFAFA/code')

# 思路
#  ·买入条件 收盘价大于均线
#  ·卖出条件 收盘价小于均线
# 版本修订
# 1.0.0 创建
version = "1.0.0"
name = "haikui"
des = "海葵 "
creatTime = "2021-05-14"
changeTime = "2021-05-14"
params = [
    {
        "name":"ma",
        "des":"均线",
        "value":"5"
    }
]
def info():
    return {"name": name, "des": des, "params": params}

from datetime import datetime
import backtrader as bt
from Tusharedata.lib import max_abs_scaler
class Haikui(bt.Strategy):
    params = (
        ('maperiod',20),
        ("printlog",False)
    )
    def log(self, txt, dt=None):
        dt = dt or self.datas[0].datetime.date(0)
        print('%s, %s' % (dt.isoformat(), txt))

    def __init__(self):
        self.log('__init__')
        self.dataclose = self.datas[0].close
        # 初始化待处理订单
        self.order = None

        bt.indicators.ExponentialMovingAverage(self.datas[0], period=25)
        bt.indicators.WeightedMovingAverage(self.datas[0], period=25,
                                            subplot=True)
        bt.indicators.StochasticSlow(self.datas[0])
        bt.indicators.MACDHisto(self.datas[0])
        rsi = bt.indicators.RSI(self.datas[0])
        bt.indicators.SmoothedMovingAverage(rsi, period=10)
        bt.indicators.ATR(self.datas[0], plot=False)

    def signal(self):
        arr = pd.Series([self.dataclose[0],self.dataclose[-1],self.dataclose[-2]]).rank()
        signal = pd.Series([arr]).apply(max_abs_scaler)
        print(signal[0].iloc[0])
        return signal[0].iloc[0]

    def next(self):
        # Simply log the closing price of the series from the reference
        self.log('Close, %.2f' % self.dataclose[0])
        if self.order:
            self.log(str(order))
            return
        signal = self.signal()
        if (signal > 0.5):
            self.log('BUY CREATE, %.2f signal %f' % (self.dataclose[0], signal))
            self.buy()
        if (signal <-0.5):
            self.log('SELL CREATE, %.2f signal %f' % (self.dataclose[0], signal))
            self.order = self.sell()


    def notify_order(self, order):
        if order.status in [order.Submitted, order.Accepted]:
            # Buy/Sell order submitted/accepted to/by broker - Nothing to do
            return

        # Check if an order has been completed
        # Attention: broker could reject order if not enough cash
        if order.status in [order.Completed]:
            if order.isbuy():
                self.log(
                    '买入成功, 价格: %.2f, 成本: %.2f, 佣金 %.2f' %
                    (order.executed.price,
                     order.executed.value,
                     order.executed.comm))

                self.buyprice = order.executed.price
                self.buycomm = order.executed.comm
            else:  # Sell
                self.log('卖出成功 EXECUTED, 成本: %.2f, Cost: %.2f, 佣金 %.2f' %
                         (order.executed.price,
                          order.executed.value,
                          order.executed.comm))

            self.bar_executed = len(self)

        elif order.status in [order.Canceled, order.Margin, order.Rejected]:
            self.log('Order Canceled/Margin/Rejected')

        self.order = None
    
    def notify_trade(self, trade):
        if not trade.isclosed:
            return

        self.log('营业利润 PROFIT, GROSS %.2f, NET %.2f' %
                 (trade.pnl, trade.pnlcomm))
    
    



#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import unittest
tindex = 1

class Test(unittest.TestCase):

    import os,sys
    import logging
    from matplotlib.dates import (HOURS_PER_DAY, MIN_PER_HOUR, SEC_PER_MIN,MONTHS_PER_YEAR, 
        DAYS_PER_WEEK,SEC_PER_HOUR, SEC_PER_DAY,num2date, rrulewrapper, 
        YearLocator,MicrosecondLocator)
    sys.path.append('/Users/admin/Documents/GitHub/UGFAFAFA/code')
    from Analyse.haikui import Haikui
    
    import backtrader as bt
    import pandas as pd

    @unittest.skipIf((tindex!=0 and tindex!=1), "reason")
    def test_base(self):
        from Tusharedata.daily import load as loaddata
        df = loaddata(code="300059.SZ")
        df = df[df["date"]>"20200101"]
        df.index=pd.to_datetime(df.date)
        df = df[['open','high','low','close','vol',"ma5","ma10","ma20","ma30"]]
        
        print(df)
        cerebro = bt.Cerebro()
        #broker设置策略
        cerebro.addstrategy(Haikui)
        #broker设置资金、手续费
        cerebro.broker.setcash(10000.0)
        cerebro.broker.setcommission(commission=0.001)
        #设置买入设置，策略，数量
        cerebro.addsizer(bt.sizers.FixedSize, stake=500) 
        # 设置数据
        data = bt.feeds.PandasData(dataname=df) 
        cerebro.adddata(data)
        logging.debug('Starting Portfolio Value: %.2f' % cerebro.broker.getvalue())
        cerebro.run()
        logging.debug('Final Portfolio Value: %.2f' % cerebro.broker.getvalue())
        cerebro.plot()

if __name__ == "__main__":
    unittest.main()