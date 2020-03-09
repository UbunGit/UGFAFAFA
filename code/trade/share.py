#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import tushare as ts
import numpy
import pandas
import os
import talib as tl
###
## 单个股票
###
class share:
    cdata = None # 股票数据
    code = None # 股票数据
    def __init__(self, code, begin= None, end= None):
        #根据股票编码初始化数据
        self.code = code
        self.cdata = ts.get_hist_data(code,start=begin, end=begin)
        self.cdata.sort_index(inplace=True)
       

    def macd(self):

        closes = numpy.array(self.cdata['close'])
        diff, dea, macd= tl.MACD(closes,
                            fastperiod=12, slowperiod=26, signalperiod=9 )
        
        self.cdata['MACD']= macd*2
        self.cdata['DEA'] = dea
        self.cdata['DIFF'] = diff
   

    def save(self):
        self.cdata.to_csv('~/share/data/'+str(self.code)+'.csv')
       

###
## 股票列表
###
filepath = '~/share/data/basics.csv'
class shares:
    basics = None # 股票列表
    def __init__(self):
        temdata = None
        if os.path.exists(filepath):
            print("股票列表--cvs")
            temdata = pandas.read_csv(filepath)
        if temdata is None:
            print("股票列表--tushare")
            temdata = ts.get_stock_basics()
            temdata.to_csv(filepath)
        self.basics = temdata

    ## 根据条件获取对应的股票列表  
    def fitter(self,key,value):
        print("根据条件获取对应的股票列表")
        return self.basics[self.basics[key]==value]


    def run(self):
        codes = numpy.array(self.basics.index)
        # for i in range(len(codes)):
        for i in range(2):
            temshare = share(code=codes[i])
            temshare.save()


if __name__ == '__main__':
    # center = shares()
    # center.run()
    # print(center.fitter("industry","纺织"))

    temdata = share('002239')
    temdata.macd()
 
