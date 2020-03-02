import tushare as ts
import logging
import talib as tl
import numpy


data =  ts.get_hist_data(code='000100',start=None,end=None) #一次性获取全部日k线数据
data.sort_index(inplace=True)
print(data)
