#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 达维策略

# 导入本地文件
import logging
import sys
sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code/")

import os
import math
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


pct = 3
begin = "20190101"
end = ""
codes =["000333.SZ","600887.SH","000001.SZ","300059.SZ"]

name = "damrey"
params = [
        {
        "name":"动能天数",
        "key":"pct",
        "value":3
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
    #code,date,count,price,free = 0
    log(" --------strategy {} --------".format(data.name))

    store1 = cerebro.store(code = code1)
    store2 = cerebro.store(code = code2)

    if data["signal"] not in codes :
        log("strategy signal==None 卖出全部 {}".format(data.name))
        for item in codes:
            store = cerebro.store(code = item)
            cerebro.seller(
                code = item,
                date = data.name,
                count = None,
                price=data["open"+item],
                free=scomm(data["open"+item]*store.count)
            )
    else:
        for item in codes:
            if data["signal"] != item:
                store = cerebro.store(code = item)
                cerebro.seller(
                    code = item,
                    date = data.name,
                    count = None,
                    price=data["open"+item],
                    free=scomm(data["open"+item]*store.count)
                )
        code = data["signal"]
        store = cerebro.store(code = code)
        if math.isnan(data["open"+code]) == False:
            bcount = int(cerebro.cash/int((data["open"+code]*101)))*100
            cerebro.buy(
                code=code,
                date =data.name,
                count= bcount,
                price = data["open"+code],
                free = bcomm(data["open"+code]*bcount)
            )

    log(" --------strategy end --------")

def signal(df,pct = 20):
    pctkeys = []
    for item in codes:
        pctkey = "pct"+item
        pctkeys.append(pctkey)
        df[pctkey] = df["close"+item].pct_change(periods=pct)
        
    df["signal0"] = pd.DataFrame(df[pctkeys]).idxmax(axis=1).str.replace("pct", "")
    df["signal"] = df["signal0"].shift(1)
    
    return df

def loaddata():

    df = None
    lastcode = None
    for item in codes:
        idf = load(code = item)
        idf = idf[idf["date"] > begin]
        idf.index= pd.to_datetime(idf["date"])
        idf = idf.rename(columns={'close':"close"+item})
        idf = idf.rename(columns={'open':"open"+item})
        if lastcode == None:
            df = idf[["close"+item,"open"+item]]
        else:
            df["close"+item] = idf["close"+item]
            df["open"+item] = idf["open"+item]
        lastcode = item
    return df





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
    close = df
    for code in codes:
        close = close.rename(columns={"close"+code:code})
  
    tdf = close[codes]

    cerebro.chartEarnings(tdf).render("../data/tem/002.html")
    cerebro.zonelist()
    print(cerebro.buylist())
    

   



