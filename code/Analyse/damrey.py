#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 达维策略

import sys,traceback
import os
import json, logging
import pandas as pd
# from .back_trading import back_trading
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

def analyse(code, param=None):
    try:
        paramjson = json.loads(param)
        ma = int(paramjson["ma"])
        rankDay = int(paramjson["rankDay"])
        # 0 获取数据
        data = loadDaily(code=code)
        logging.debug(">>>>> analyse loadDaily end")
        # 计算所需的数据
        ## ma 
        mas = [5,10,20,30]
        if ma not in mas:
            mas.append(ma)
        lib.mas(data, mas)
        logging.debug(">>>>> analyse mas end")
        lib.rank(data,"ma"+str(ma),rankDay)
        logging.debug(">>>>> analyse rank end")
        data["signal"] = data["ma"+str(ma)+"_rank_standard"]
        logging.debug(">>>>> analyse signal end")
        lib.itemv(data, items=["close"], axis=[5, 10, 20, 30])
        logging.debug(">>>>> analyse closev end")
        outpath = datapath+"/damrey/"+code
        mkdir(outpath)
        logging.debug(">>>>> analyse mkdir end")
        data.to_csv(outpath + "/result.csv")
        logging.debug(">>>>> analyse to_csv end")
       
    except:
        print('---- error begin ----')
        traceback.print_stack()
        print('---- error end ----')
      
def backtrading(code=None ,begin=None, end = None, signal="signal"):
    try:
        outfile = datapath+"/damrey/"+code+"/result.csv"
        if os.path.exists(outfile):
            df = pd.read_csv(outfile)
            logging.debug(">>>>> analyse backtrading read_csv end")
            df = back_trading(df,begin,end,signal)
            logging.debug(">>>>> analyse back_trading  end")
            logging.debug(df.info())
            return df
        logging.debug(">>>>> analyse backtrading os.path.exists else")
        pd.DataFrame()
    except:
        print('---- error begin ----')
        traceback.print_stack()
        print('---- error end ----')
        return pd.DataFrame()


    
   



