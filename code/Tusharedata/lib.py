#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging
import talib as tl
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
    data[key]= tl.MA(data['close'],timeperiod=ma)
    logging.info("ma %s END",ma)



