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

def clog(msf):
    logging.debug(msf)

# 加载数据
ma = 20
code = "600036.SH"
begin = "20200101"
log = clog



'''
股价与均线计较策略
'''
name = "haikui"
params = [
        {
        "name":"均线天数",
        "key":"ma",
        "value":20
        },
        {
        "name":"开始时间",
        "key":"begin",
        "value":"20190101"
        },
        {
        "name":"结束时间",
        "key":"end",
        "value":""
        },
        {
        "name":"股票列表",
        "codes":"end",
        "value":["000333.SZ","600887.SH","000001.SZ","300059.SZ"]
        },
    ]
def info():
    return {
        "name":name,
        "params":params
    }

def strategy(index,data,cerebro):

    store = cerebro.store(code = data["code"])
    if data["signal"]>0.00 and store.count<=0:
        bcount = int(cerebro.cash/int((data["close"]*100)))*100
        cerebro.buy(data["code"],date =data.name, count= bcount ,price = data["open"],free = 0)
    if data["signal"]<=0 and store.count>=0:
        cerebro.seller(code = data["code"],date = data.name,count = None, price= data["open"],free = 0)


def signal(df):

    from Tusharedata.lib import max_abs_scaler
    from Tusharedata.lib import mas
    from Tusharedata import lib
    mas(df,[5,10,20,30])
    df["signal_0"] = (df["close"]-df["ma"+str(ma)]) / df["ma"+str(ma)]

    df["signal_1"] = lib.rank(df,"ma"+str(20),3)
    df["signal_1"] = df[["signal_1"]].apply(max_abs_scaler)
    def temfun(x):
        return 1 if x>=0.8 else 0

    df["signal_2"] = df["signal_1"].apply(temfun)
    df["signal"] =  df["signal_0"].shift(1)
    return df


def loaddata():

    df = load(code = code)
    df = df[df["date"] > begin]
    df = df.rename(columns={'ts_code':'code'})
    df.index= pd.to_datetime(df["date"])
    return df

def setup(param=None):

    global ma, code, begin
    if param != None:
        if "ma" in param.keys():
            ma = param["ma"]
        if "code" in param.keys():
            code = param["code"]
        if "begin" in param.keys():
            begin = param["begin"]    

    df = loaddata()
    df = signal(df)

    # 加载回测系统
    from rolltrader.cerebro import Cerebro
    cerebro = Cerebro()
    cerebro.strategy = strategy
    cerebro.data = df
    cerebro.log = log
    cerebro.run()

    from rolltrader.pycharts import someline
    close = df.rename(columns={"close":code})
    tdf = close[code]
    cerebro.chartEarnings(tdf).render("../data/tem/002.html")




if __name__ == "__main__":
    
    # 加载数据
    ma = 10
    code = "600036.SH"
    begin = "20200101"

    setup(param={
        "ma":10,
        "code":"600036.SH",
        "begin":"20200101"
    })
    


