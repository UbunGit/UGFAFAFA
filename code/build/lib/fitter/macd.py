#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import numpy
import pandas
import sys,logging,time
formattime = (time.strftime('%Y-%m-%d',time.localtime(time.time())))
logging.basicConfig(level=logging.NOTSET)  # 设置日志级别
##
# 找出  
# 条件1:macd>0 dea >0 diff>0 
# 条件2:diff>dea 
# 条件3:close>ma20 
# 条件4:k>30 
##
def macdfitter(date):

    macddata = loadData(date)
    macddata = macddata[macddata.MACD>0]
    macddata = macddata[macddata.DIFF<=0]
    macddata = macddata[macddata.DEA<=0]
    macddata.to_csv('~/share/tem/macdChoose_'+str(date)+'.csv')
    return macddata.to_json(orient='records')

##
# 加载数据
##
def loadData(date):
    todyfile = '~/share/tem/shares_'+str(date)+'.csv'

    logging.info("读取"+todyfile)
    temdata = pandas.read_csv(todyfile,dtype={'code':object})
    print(temdata)
    return temdata

     

if __name__ == '__main__':

    print(macdfitter())