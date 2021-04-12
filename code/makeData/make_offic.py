#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 目的
# 创建股票前n天的收盘集合与后m天的收盘价
import os
import numpy
import pandas
import logging
import talib as tl

logging.basicConfig(level=logging.NOTSET)  # 设置日志级别
datapath = "/Users/admin/Documents/github/UGFAFAFA/data/cvs"

# step1 获取数据

def getdata(code="600111.sh"):
    datafile = os.path.join(datapath,str(code)+'.csv')
    if os.path.exists(datafile):
        temdata = pandas.read_csv(datafile ,dtype={"date":"string"}, index_col=0)
        temdata = temdata.sort_values(by='date')
        if len(temdata)>0:
            return temdata
        else:
            raise Exception("temdata id empty")
    else:
        raise Exception("datafile not exists!", datafile)

        

# 处理数据
def mapdata(datas):
    df = datas
    # 获取股票前n天的 dataform ？

    # 计算ma5 ma30 以及差值
    df['ma5'] = tl.MA(datas['close'],timeperiod=5)
    df['ma30'] = tl.MA(datas['close'],timeperiod=20)
    df["xclose"] = df['close'].shift(-1)
    logging.debug(df.loc[:,["date","close","xclose"]])
    df['lable'] = df['ma5'] / df['ma30']

    

    # 回去股票后m天的收盘价
    df['text'] = df['close']/df["xclose"]

    logging.debug(df['text'].corr(df['lable'])) 

    svdata =  df.loc[:,['date','lable','text']]
    logging.debug(svdata.head())
    svdata.to_csv('./data/traindata/ma5-30_600111_SH.csv')



  

# 输出

# 保存


import unittest

class TestStores(unittest.TestCase):

    def setUp(self):
        logging.info ("setup...")

    def test_getdata(self):
        logging.info("test_getdata.")
        try:
            datas = getdata(code="300022.sz")
            logging.debug(". datas length is:%s .",len(datas))
            mapdata(datas)
        except Exception as err:
            logging.error (err)
      
      
        


if __name__ == '__main__':
    unittest.main()