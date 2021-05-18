#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 导入本地文件
import logging
import sys
sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code/")

import os
import pandas as pd
import numpy as np
import talib as tlb
import matplotlib.pyplot as plt
from Tusharedata.daily import load

'''
股价与均线计较策略
'''
def strategy(data,cerebro):
    
    if data["signal"]>0.00 and cerebro.position<=0:
        bcount = int(cerebro.cash/int((data["close"]*100)))*100
        bprice = data["close"]
        return bcount,bprice,0,0
    if data["signal"]<=0 and cerebro.position>0:
        scount = cerebro.position
        sprice = data["close"]
        return 0, 0, scount,sprice
    return 0,0,0,0

def signal(df,ma):

    from Tusharedata.lib import max_abs_scaler
    from Tusharedata.lib import mas
    from Tusharedata import lib
    mas(df,[5,10,20,30])
    df["signal_0"] = (df["close"]-df["ma"+str(ma)]) / df["ma"+str(ma)]

    df["signal_1"] = lib.rank(df,"ma"+str(30),3)
    df["signal_1"] = df[["signal_1"]].apply(max_abs_scaler)
    def temfun(x):
        return 1 if x>=0.8 else 0

    df["signal_2"] = df["signal_1"].apply(temfun)
    df["signal"] =  df["signal_2"]*df["signal_0"]
    print("signal")



if __name__ == "__main__":

    def log(msf):
        logging.debug(msf)
    #  引入文件
    from Tusharedata.daily import load
    import pandas as pd

    # 加载数据
    ma = 20
    code = "300059.SZ"
    df = load(code = code)
    df = df[df["date"] > "20160101"]
    df.index= pd.to_datetime(df["date"])
   
    signal(df,ma)

    # 加载回测系统
    from rolltrader.cerebro import Cerebro
    cerebro = Cerebro()
    cerebro.strategy = strategy
    cerebro.data = df
    cerebro.log = log
    cerebro.run()

    from rolltrader.pycharts import someline
    page = cerebro.pycharts(name = '海葵交易策略 {} {}'.format(code,ma))
    page.add(
        someline(cerebro.result,["signal_0","signal_1","signal_2","signal"],"买卖信号")
    )
    cerebro.describe.positions.to_csv("../data/tem/positions.csv")
    cerebro.result.to_csv("../data/tem/result.csv")
    path = page.render("../data/tem/result.html")
    print(path)
    

    
    df = df.join(edf)
    print(df[["date","cash","position"]])