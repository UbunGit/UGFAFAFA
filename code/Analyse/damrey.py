#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 达维策略

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
from rolltrader.cerebro import Cerebro
from rolltrader.free import bcomm,scomm

'''
两支股票轮动交易 
'''
def strategy(index,data,cerebro):
    #code,date,count,price,free = 0
    

    store1 = cerebro.store(code = code1)
    store2 = cerebro.store(code = code2)
    # if np.isnan(data["close"+code1])  or np.isnan(data["close"+code2]):
    #     return
    if data["signal"] == None:
        cerebro.seller(
            code = code1,
            date = data.name,
            count = store1.count,
            price=data["open"+code1],
            free=scomm(data["open"+code1]*store1.count)
        )
        cerebro.seller(
            code = code2,
            date = data.name,
            count = store2.count,
            price=data["open"+code2],
            free=scomm(data["open"+code2]*store2.count)
        )
    if data["signal"] == code1 and store1.count<=0:
        cerebro.seller(
            code = code2,
            date = data.name,
            count = store2.count,
            price=data["open"+code2],
            free=scomm(data["open"+code2]*store2.count)
        )
        
        bcount = int(cerebro.cash/int((data["open"+code1]*101)))*100
        cerebro.buy(
            code=code1,
            date =data.name,
            count= bcount,
            price = data["open"+code1],
            free = bcomm(data["open"+code1]*bcount)
        )
    if data["signal"] == code2 and store2.count<=0:
        
        cerebro.seller(
            code = code1,
            date = data.name,
            count = store1.count,
            price=data["open"+code1],
            free=scomm(data["open"+code1]*store1.count)
        )
        price = 0 if np.isnan(data["open"+code2]) else data["open"+code2]
        bcount = int(cerebro.cash/int((price*101)))*100
        cerebro.buy(
            code2,
            date =data.name,
            count= bcount,
            price = data["open"+code2],
            free = bcomm(data["open"+code2]*bcount)
        )

def signal(df,pct = 20):
    df["pct"+code1] = df["close"+code1].pct_change(periods=pct)
    df["pct"+code2] = df["close"+code2].pct_change(periods=pct)
    def signal(data):
        if np.isnan(data["close"+code1])  or np.isnan(data["close"+code2]):
            return None
        if np.isnan(data["pct"+code1])  or np.isnan(data["pct"+code2]):
            return None
        if data["pct"+code1]<0 and data["pct"+code2]<0:
            return None
        if data["pct"+code1] > data["pct"+code2]:
            return code1
        else:
            return code2
    df["signal0"] = df.apply(signal, axis= 1)
    df["signal"] = df["signal0"].shift(1)
    return df

def loaddata():
    df1 = load(code = code1)
    df1 = df1[df1["date"] > "20140101"]
    df1.index= pd.to_datetime(df1["date"])
    # df1.set_index(["date"], inplace=True)
    df1 = df1.rename(columns={'close':"close"+code1})
    df1 = df1.rename(columns={'open':"open"+code1})

    df2 = load(code = code2)
    # df2.set_index(["date"], inplace=True)
    df2 = df2[df2["date"] > "20140101"]
    df2.index= pd.to_datetime(df2["date"])
    df2 = df2.rename(columns={'close':"close"+code2})
    df2 = df2.rename(columns={'open':"open"+code2})
   
    df = pd.merge(
        left=df1[["close"+code1,"open"+code1]],
        right=df2[["close"+code2,"open"+code2]],
        left_index=True,
        right_index=True,
        how="left"
    )
    return df


code1 = "601865.SH"
code2 = "002594.SZ"
pct = 20
begin = "20200101"
end = ""

if __name__ == "__main__":

    def log(msf):
        logging.debug(msf)

    df = loaddata()
    df = signal(df,pct=pct)
    df.to_csv("../data/tem/002.csv")
    cerebro = Cerebro()
    cerebro.cash = 100000
    cerebro.strategy = strategy
    cerebro.data = df
    cerebro.log = log
    cerebro.run()
    buylist = cerebro.buylist()
    print(buylist)
    close = df.rename(columns={"close"+code1:code1})
    close = close.rename(columns={"close"+code2:code2})
    tdf = close[[code1,code2]]

    cerebro.chartEarnings(tdf).render("../data/tem/002.html")
    
    print(cerebro.buylist())
    

   



