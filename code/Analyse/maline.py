#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code/")

import json
import pandas as pd
from .line import lineType
from Tusharedata import lib, loadDaily
from config import dataPath as root
from file import mkdir

datapath = root+"/output"


# 获取策略的信息
def info():
    return {"name": "maline", "des": "均线相交", "parameter": [{"name": "ma1", "des": "第一条均线", "value":"5"},{"name": "ma2", "des": "第二条均线", "value":"30"}]}

def signal(series,ma1,ma2):
    return int(
        (series["ma" + str(ma1) + "_-1"] <= series["ma" + str(ma2) + "_-1"]) &
        (series["ma" + str(ma1)] > series["ma" + str(ma2)])
    )
     
# 分析
def analyse(code, begin=None, end=None, param=None):
    paramjson = json.loads(param)
    print(code)
    print(begin)
    print(end)
    print(param)

    ma1 = int(paramjson["ma1"])
    ma2 = int(paramjson["ma2"])

    # 0 获取数据
    data = loadDaily(code=code)
    # 计算所需数据
    lib.ma(data, ma1)
    lib.ma(data, ma2)
    lib.shift(data, ["ma" + str(ma1), "ma" + str(ma2)], [-1])
    lib.itemv(data, items=["close"], axis=[5, 10, 20, 30])
    data = data.dropna(axis=0, how="any")
    
    data["b"] = data.apply(signal,axis=1,args=(ma1,ma2))

    outpath = datapath+"/maline/"+code
    mkdir(outpath)
    data.to_csv(outpath + "/result.csv")
    rdata = data[data["b"]==1]
    print(rdata.values)
    return rdata



if __name__ == '__main__':

    param = {"ma1": 5, "ma2": 30}
    analyse(code="000002.SZ", begin=None, end=None, param='{"ma2":"25","ma1":"8"}')
