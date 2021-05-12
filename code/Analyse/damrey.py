#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 达维策略

import sys
import os
import json
import pandas as pd
from .line import lineType
from .draw import draw
from .back_trading import back_trading
from Tusharedata import lib, loadDaily
from config import dataPath as root
from file import mkdir

datapath = root+"/output"
# 思路
#  ·结合快均线与慢均线的趋势确定股票未来走势
#  ·根据快均线与慢均线之间的差值作为权重分配值
# 版本修订
# 1.0.0 创建
version = "1.0.0"
name = "damrey"
des = "达维 "
creatTime = "2021-05-08"
changeTime = "2021-05-08"
params = [
    {
        "name":"ma",
        "des":"均线",
        "value":"5"
    },

    {
        "name":"rankDay",
        "des":"趋势确定天数",
        "value":"5"
    }
]
def info():
    return {"name": name, "des": des, "params": params}

def analyse(code,begin = None,end= None, param=None):

    paramjson = json.loads(param)
    ma = int(paramjson["ma"])
    rankDay = int(paramjson["rankDay"])

    # 0 获取数据
    data = loadDaily(code=code)
    print(data)
    # 计算所需的数据
    ## ma 
    mas = [5,10,20,30]
    if ma not in mas:
        mas.append(ma)
    lib.mas(data, mas)

    lib.rank(data,"ma"+str(ma),rankDay)
    data["signal"] = data["ma"+str(ma)+"_rank_standard"]
    lib.itemv(data, items=["close"], axis=[5, 10, 20, 30])
    outpath = datapath+"/damrey/"+code
    mkdir(outpath)
    data.to_csv(outpath + "/result.csv")
    return data



def catchdata(code):
    
    outfile = datapath+"/damrey/"+code+"/result.csv"
    if os.path.exists(outfile):
        return pd.read_csv(outfile)
    else: 
        return None
   



