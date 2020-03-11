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
def macdChoose():
    todydata = loadData()
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
    macddata.to_csv("~/share/tem/macdChoose_2020-03-02.csv")
    print(macddata["code"])

##
# 加载数据
##
def loadData():
    todyfile = '~/share/tem/shares_2020-03-02.csv'
    try:
        temdata = pandas.read_csv(todyfile)
        return temdata
    except Exception as e:
        print('except:', e)
        return None

if __name__ == '__main__':
    macdChoose()