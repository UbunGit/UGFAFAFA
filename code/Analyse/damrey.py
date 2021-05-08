#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 达维策略

import sys
sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code/")

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
        "key":"",
        "des":"",
        "value":""
    }
]


def analyse(code, param=None):
    paramjson = json.loads(param)
    ma1 = int(paramjson["ma1"])
    ma2 = int(paramjson["ma2"])

    # 0 获取数据
    data = loadDaily(code=code)

    # 计算所需的数据
    ## ma1 ma2
    lib.mas(data, [ma1,ma2])
    ## ma1 ma2 趋势
    lib.rank(data,"ma"+str(ma1),10)
    lib.rank(data,"ma"+str(ma2),10)

    data["signal"] = data["ma"+str(ma2)+"_rank_standard"]

    lib.itemv(data, items=["close"], axis=[5, 10, 20, 30])
    data = data.dropna(axis=0, how="any")
    data = back_trading(data,"signal")


    outpath = datapath+"/damrey/"+code
    mkdir(outpath)
    data.to_csv(outpath + "/result.csv")

    # tdraw = draw(data)
    # tdraw.draw()


   



