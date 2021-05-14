#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 海葵策略

import sys,traceback
import os
import json, logging
import pandas as pd
from .back_trading import back_trading
from Tusharedata import lib, loadDaily
from config import dataPath as root
from file import mkdir

datapath = root+"/output"

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

def analyse(df, param=None):
    def signal(df,ma):
        return df["date"]

    paramjson = json.loads(param)
    print(df.info)
    print(paramjson)
    ma = int(paramjson["ma"])
    # 计算所需数据
    lib.ma(data, ma)
    df["signal_0"] = (df["close"]-df["ma"+str(ma)]) / df["ma"+str(ma)]
    
    data["b"] = data.apply(signal,axis=1,args=(ma,))

    return rdata
