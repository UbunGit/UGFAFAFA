#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import numpy
import pandas


##
# 找出  
# 条件1:macd>0 dea >0 diff>0 
# 条件2:diff>dea 
# 条件3:close>ma20 
# 条件4:k>30 
##
def macdfitter(date):
    todydata = loadData(date)
    macddata = todydata[todydata.MACD>0]
    macddata = macddata[macddata.DEA>0]
    macddata = macddata[macddata.DIFF>0]
    macddata = macddata[macddata.DIFF>macddata.DEA]
    macddata = macddata[macddata.close>macddata.ma10]

    macddata = macddata[todydata.MACD_R>0]
    macddata = macddata[todydata.K_R>0]
    macddata = macddata[todydata.MA20_R>0]
    macddata = macddata[todydata.MA10_R>0]
    macddata = macddata[macddata.k<88]
    macddata.to_csv('~/share/tem/macdChoose_'+str(date)+'.csv')
    return macddata.to_json(orient='records')

##
# 加载数据
##
def loadData(date):
    todyfile = '~/share/tem/shares_'+str(date)+'.csv'
    try:
        temdata = pandas.read_csv(todyfile)
        return temdata
    except Exception as e:
        print('except:', e)
        return None

if __name__ == '__main__':
    print(macdfitter('2020-03-02'))