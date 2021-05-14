#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from datetime import date
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

'''
分析股价高于某条均线买入，低与某条均线卖出情况
'''



def masignal(data,ma):
    return (data["close"]-data["ma"+str(ma)])/data["ma"+str(ma)]

def done(df,ma=5):
    
    print(df.info())
    # 计算收盘价与ma比率
    df["close_ma_v"] = df.apply(masignal,axis=1,args=(ma,))
    df["close_s_1"] = df["close"].shift(-1)
    df["close_v"] = (df["close"].shift(-1) - df["close"] )/df["close"]
    print(df.corr())
   
    df["close_ma_v"].describe().plot().bar(x=df.index,height="max")
    plt.show()
    

if __name__ == '__main__':
    import sys
    sys.path.append('/Users/admin/Documents/GitHub/UGFAFAFA/code')
    from Tusharedata.daily import load
    from Tusharedata import lib

    code = "600089.SH"
    begin = "20190101"
    end = "20210101"
    ma = 30
   
    '''
    获取股票数据
    '''
    df = load(code)
    print(df.info())
    lib.mas(df,[ma])
    df = df[df["date"]>begin]
    df = df[df["date"]<end]
    done(df,ma=ma)