#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import pandas as pd
from line import lineType
sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code/")
from Tusharedata import lib, loadDaily

datapath = "/Users/admin/Documents/github/UGFAFAFA/data/tem"
# 获取策略的信息
def info():

    return {
        "name":"均线相交",
        "des":"均线相交",
        "param":[
            {
                "key":"", 
                "des":"" # 描述
            }
        ]
    }

# 分析
def analyse(code, begin = None , end = None, param = None):

    ma1 = param["ma1"]
    ma2 = param["ma2"]
    # 0 获取数据
    data = loadDaily()
    # 计算所需数据
    lib.ma(data,ma1)
    lib.ma(data,ma2)
    lib.shift(data, ["ma"+str(ma1),"ma"+str(ma2)], [1])
    lib.itemv(data, items=["close"], axis=[5,10,20,30])
    data = data.dropna(axis = 0, how = "any")
    data["select"] = (
        (data["ma"+str(ma1)+"_1"] <= data["ma"+str(ma2)+"_1"]) & 
        (data["ma"+str(ma1)] > data["ma"+str(ma2)])
    )
    data.to_csv(datapath+"/tem.csv")
    return 

if __name__ == '__main__':
    param = {
       "ma1" : 5,
       "ma2" : 30
    }
    analyse(code="000002.SZ", begin = None, end = None, param = param)



       