##!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging
import talib as tl
import pandas as pd
import numpy as np
logging.basicConfig(level=logging.NOTSET)  # 设置日志级别

# 数据错位
# item 对应的列名[]
# axis 错位[]
def shift(data,itmes,axis):
    _data = data
    for item in itmes:
        for axi in axis:
            sname = item+'_'+str(axi)
            data[sname] = _data[item].shift(-axi)
    return
            
# 获取后m天的比率
def itemv(data, items, axis):
    _data = data
    for item in items:
        for axi in axis:
            sname = item+str(axi)+"v"
            data[sname] = (data[item].shift(-axi) / data[item])*10
    
def ma(data, ma):
    
    logging.info("ma %s BEGIN",ma)
    key = "ma"+str(ma)
    data[key]= tl.MA(data['close'],timeperiod=int(ma))
    logging.info("ma %s END",ma)

# 批量计算均值
def mas(data, mas):
    logging.info("mas BEGIN")
    for ma in mas:
        key = "ma"+str(ma)
        data[key]= tl.MA(data['close'],timeperiod=int(ma))
    logging.info("mas  END")

# 趋势
# data 数据
# column 类型
# axis 多少天
def rank(data,column,axis):
    df = data
    key = column+"_rank"
    df[key] = df[column].rolling(axis+1).apply(lambda x: pd.Series(x).rank().iloc[-1])
    df[key+"_standard"] = 2 * (df[key] - axis -1)/ axis + 1
    print(df[[key,key+"_standard"]])
    print(data[[key,key+"_standard"]])

# 归一化到【0 ～ 1】
max_min_scaler = lambda x : (x-np.min(x))/(np.max(x)-np.min(x))
# 归一化到【-1 ～ 1】
max_abs_scaler = lambda x : 2*((x-np.min(x))/(np.max(x)-np.min(x)))-1




