#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import numpy
import pandas
import sys,logging
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
    macddata = macddata[macddata.DEA>0]
    macddata = macddata[macddata.DIFF>0]
    macddata = macddata[macddata.DIFF>macddata.DEA]
    macddata = macddata[macddata.close>macddata.ma10]
    macddata = macddata[macddata.MACD_R>1.5]
    macddata = macddata[macddata.K_R>50]
    macddata = macddata[macddata.MA20_R>1.5]
    macddata = macddata[macddata.MA10_R>1.5]
    macddata = macddata[macddata.MA5_R>3]
    macddata = macddata[macddata.k<75]
    macddata.to_csv('~/share/tem/macdChoose_'+str(date)+'.csv')
    return macddata.to_json(orient='records')

##
# 加载数据
##
def loadData(date):
    todyfile = '~/share/tem/shares_'+str(date)+'.csv'
    try:
        logging.info("读取"+todyfile)
        temdata = pandas.read_csv(todyfile,dtype={'code':object})
        print(temdata)
        return temdata
    except Exception as e:
        logging.info(e)
        sys.exit(1)
     

if __name__ == '__main__':
    print(macdfitter('2020-03-11'))