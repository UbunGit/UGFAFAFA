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

def strategy(data,cerebro):
    
    if data["signal"]>0.5 and cerebro.position<=0:
        bcount = int(cerebro.cash/int((data["close"]*100)))*100
        bprice = data["close"]
        return bcount,bprice,0,0
    if data["signal"]<0.5 and cerebro.position>0:
        scount = cerebro.position
        sprice = data["close"]
        return 0, 0, scount,sprice
    return 0,0,0,0

def signal(df,ma):

    from Tusharedata.lib import max_abs_scaler
    from Tusharedata.lib import mas
    mas(df,[5,10,20,30])
    df["signal_0"] = (df["close"]-df["ma"+str(ma)]) / df["ma"+str(ma)]
    df["signal_1"] = df[["signal_0"]].apply(max_abs_scaler)
    df["signal_2"] = (2*df["signal_1"])-1
    df["signal_3"] = -np.square(df["signal_2"]) + 1 
    df["signal_4"] = df["signal_0"]>0
    df["signal_4"] = df["signal_4"].astype("int")
    df["signal_4"] = (2*df["signal_4"])-1
    df["signal"] = df["signal_4"]*df["signal_3"]


if __name__ == "__main__":

    def log(msf):
        logging.debug(msf)
    #  引入文件
    from Tusharedata.daily import load
    import pandas as pd

    # 加载数据
    ma = 30
    df = load(code="300059.SZ")
    df = df[df["date"] > "20210101"]
    df.index= pd.to_datetime(df["date"])
   
    signal(df,ma)

    # 加载回测系统
    from rolltrader.cerebro import Cerebro
    cerebro = Cerebro()
    cerebro.strategy = strategy
    cerebro.data = df
    cerebro.log = log
    edf = cerebro.run()

    page = cerebro.pycharts()
    path = page.render("./result.html")
    print(path)
    
    df = df.join(edf)
    print(df[["date","cash","position"]])