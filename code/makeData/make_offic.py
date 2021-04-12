#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 目的
# 创建股票前n天的收盘集合与后m天的收盘价
import os
import numpy
import pandas

import talib as tl
from matplotlib import pyplot as plt 
from datetime import datetime
import logging

logging.basicConfig(level=logging.NOTSET)  # 设置日志级别
datapath = "./data/cvs"

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
    # 计算ma5 ma30 以及差值
    df['ma5'] = tl.MA(datas['close'],timeperiod=5)
    df['ma30'] = tl.MA(datas['close'],timeperiod=20)
    df["xclose"] = df['close'].shift(-5)
    logging.debug(df.loc[:,["date","close","xclose"]])
    df['lable'] = df['ma5'] / df['ma30']

    # 回去股票后m天的收盘价
    df['text'] = df['close']/df["xclose"]
    logging.debug(df['text'].corr(df['lable'])) 
    return df.loc[:,['date','lable','text','close','xclose']]

# 判断ma5上传ma30
def matype(data,max,may):
    df = data
    df['max'] = tl.MA(df['close'],timeperiod = max)
    df['may'] = tl.MA(df['close'],timeperiod = may)
    df['max_'] = df['max'].shift(-1)
    df['max+'] = df['max'].shift(1)
    df['may_'] = df['may'].shift(-1)
    df['may+'] = df['may'].shift(1)
    df['mat'] =  ((df['max_'] <= df['may_']) & (df['max+'] >= df['may+']))
    data['mat'] = df['mat']

# 获取后m天的收盘加与当天收盘加比率
def clostlv(data,m):
    df = data
    df["close_v"] = df['close'].shift(-m) / df['close']
    data['close_v'] = df["close_v"]


# 输出

# 保存


import unittest

class TestStores(unittest.TestCase):

    def setUp(self):
        logging.info ("setup...")
    @unittest.skip("跳过该测试项") 
    def test_getdata(self):
        logging.info("test_getdata.")
        try:
            code = "300022.sz"
            datas = getdata(code=code)
            logging.debug(". datas length is:%s .",len(datas))
            svdata = mapdata(datas)
            logging.debug(svdata.head())
          
            svdata.to_csv('./data/traindata/%s.csv' %(code))

            # pltdata = svdata[30:300]
            # logging.debug(pltdata)

            # pltdata["x"] = [datetime.strptime(d, '%Y%m%d') for d in pltdata['date']]

            # plt.title("Matplotlib demo") 
            # plt.xlabel("x date") 
            # plt.ylabel("y lable") 
            # plt.plot(pltdata["x"],pltdata["lable"]) 
            # plt.plot(pltdata["x"],pltdata["text"]) 
            # plt.show()
        except Exception as err:
            logging.error (err)
    
    def test_matype(self):
        logging.info("test_getdata.")
        try:
            code = "601138.SH"
            datas = getdata(code=code)
            matype(datas,5,30)
            clostlv(datas,30)
            tdata = datas.loc[datas['mat']==True,['close_v']]
            logging.debug(tdata.describe())
            logging.debug(datas.loc[datas['mat']==True,['mat','close_v']])

        except Exception as err:
            logging.error (err)

      
        


if __name__ == '__main__':
    unittest.main()