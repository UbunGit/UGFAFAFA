#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import tushare as ts
import numpy
import pandas
import os,time,logging
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
        logging.debug("根据股票编码初始化数据 code:%s 开始：%s 结束：%s",code,begin,end)
        self.code = code
        tsda = self.load()
        if tsda is None:
            tsda = ts.get_hist_data(code)
            if(tsda is None):
                return
            tsda.sort_index(inplace=True)
            tsda["date"] = tsda.index
            tsda = self.macd(tsda)
            tsda = self.kdj(tsda)
            tsda = self.real(tsda)
            self.save(tsda)
        if(tsda is None):
            return

        self.cdata = tsda
        if begin is not None:
            self.cdata = self.cdata[self.cdata['date'] >= begin]
        if end is not None:
            self.cdata = self.cdata[self.cdata['date']<= end]
        logging.debug("cdata:%s",self.cdata)
        # self.cdata['date'] = self.cdata.index


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

    def real(self, data):
        try:
            macd_r = tl.LINEARREG_ANGLE(data['MACD'], timeperiod=3)
            data['MACD_R']= macd_r

            diff_r = tl.LINEARREG_ANGLE(data['DIFF'], timeperiod=3)
            data['DIFF_R']= diff_r

            k_r = tl.LINEARREG_ANGLE(data['k'], timeperiod=3)
            data['K_R']= k_r

            ma5_r = tl.LINEARREG_ANGLE(data['ma5'], timeperiod=3)
            data['MA5_R']= ma5_r

            ma10_r = tl.LINEARREG_ANGLE(data['ma10'], timeperiod=3)
            data['MA10_R']= ma10_r

            ma20_r = tl.LINEARREG_ANGLE(data['ma20'], timeperiod=3)
            data['MA20_R']= ma20_r

            

        except Exception as e:
            print('except:', e)
        finally:
            return data



    def save(self,data):
        data.to_csv('~/share/data/'+str(self.code)+'.csv')

    def load(self):
        sharefile = '~/share/data/'+str(self.code)+'.csv'
        try:
            temdata = pandas.read_csv(sharefile)
            dates = numpy.array(temdata['date'])
            enddate = dates[-1:][0]
            if(dates[-1:])>=formattime:
                return temdata
        except Exception as e:
            print('except:', e)
            time.sleep(0.1)
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

        

if __name__ == '__main__':
    cshare = share('300022','2019-10-01','2020-12-01')
    print(cshare.cdata)
    # print(cshare.cdata.to_json(orient='records'))
    
 
