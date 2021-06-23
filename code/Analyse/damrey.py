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
from .parameter import valueof

'''
两支股票轮动交易 
'''


pct = 3
begin = "20190101"
end = ""
codes =["000333.SZ","600887.SH","000001.SZ","300059.SZ"]

name = "damrey"
parameter = [
        {
        "name":"动能天数",
        "key":"pct",
        "value":"3"
        },
    ]

def info():
    return {
        "name":name,
        "des":"达维",
        "parameter":parameter,
        "codes":codes
    }

def log(msf):
    logging.debug(msf)

def strategy(index,data,cerebro):
    #code,date,count,price,free = 0
    log(" --------strategy {} --------".format(data.name))
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

def signal(df,parameter):

    pct = int(valueof(parameter,"pct"))
    pctkeys = []
    for item in codes:
        pctkey = "pct"+item
        pctkeys.append(pctkey)
        df[pctkey] = df["close"+item].pct_change(periods=pct)
        
    df["signal0"] = pd.DataFrame(df[pctkeys]).idxmax(axis=1).str.replace("pct", "")
    df["signal"] = df["signal0"].shift(1)
    
    return df






