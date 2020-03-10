#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import tushare as ts
import numpy
import pandas
import os,time
import talib as tl

formattime = (time.strftime('%Y-%m-%d',time.localtime(time.time())))
###
## 单个股票
###
class share:
    cdata = None # 股票数据
    code = None # 股票数据
    def __init__(self, code, begin= None, end= None):
        #根据股票编码初始化数据
        self.code = code
        tsda = self.load()
        if tsda is None:
            tsda = ts.get_hist_data(code)
        if(tsda is None):
            return
        tsda.sort_index(inplace=True)
        tsda['date'] = tsda.index
        tsda = self.macd(tsda)
        tsda = self.kdj(tsda)
        self.save(tsda)
        self.cdata = tsda[tsda['date'] >= begin]
        if end is not None:
            self.cdata = tsda[tsda['date']<= end]

    def macd(self,data):

        closes = numpy.array(data['close'])
        diff, dea, macd= tl.MACD(closes,
                            fastperiod=12, slowperiod=26, signalperiod=9 )
        
        data['MACD']= macd*2
        data['DEA'] = dea
        data['DIFF'] = diff
        return data

    def kdj(self, data, fastk_period=9, slowk_period=3, slowd_period=3):
        indicators={}
        #计算kd指标
        closes = numpy.array(data['close'])
        highs = numpy.array(data['high'])
        lows = numpy.array(data['low'])
        k, d = tl.STOCH(highs, lows, closes, fastk_period=9, slowk_period=3, slowd_period=3)
        data['k']= k
        data['d'] = d
        data['j'] = 3 * k - 2 * d
        return data

    def save(self,data):
        data.to_csv('~/share/data/'+str(self.code)+'.csv')

    def load(self):
        sharefile = '~/share/data/'+str(self.code)+'.csv'
        if os.path.exists(sharefile):
            temdata = pandas.read_csv(sharefile)
            dates = numpy.array(temdata['date'])
            if(dates[-1:])>=formattime:
                return temdata
        time.sleep(1)
        return None
       

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


def run():
    l_shares = shares()
    fitters = l_shares.basics
    codes = numpy.array(fitters.index)
    sharlist = pandas.DataFrame()
    sharecodes = []
    for i in range(len(codes)):
        temshare = share(codes[i],'2020-01-01', formattime)
        if temshare.cdata is not None:
            sharlist = sharlist.append(temshare.cdata[-1:])
            sharecodes.append(codes[i])
        sharlist["code"]= sharecodes 
        print(codes[i],"[",i,"/",len(codes),"]")
        sharlist.to_csv("~/share/tem/todyshare.csv")
        
    
    print(sharlist)
        

if __name__ == '__main__':
    run()

    
 
