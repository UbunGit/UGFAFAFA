#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from datetime import date
import pandas as pd
import matplotlib.pyplot as plt

'''
分析股价高于某条均线买入，低与某条均线卖出情况
'''

code = "300022.SZ"
begin = "20200101"
end = "20210101"

def masignal(data,ma):
    return (data["close"]-data["ma"+str(ma)])/data[ma]
def done(df,ma=5):

    '''
    获取股票数据
    '''
    print(df.info())
    
    # 计算收盘价与ma比率
    df["close_ma_v"] = df.apply(masignal,axis=1,args=(ma,))

   
    print(df[["close","close_ma_v","ma"+str(ma)]])
    plt.hist(df["close_ma_v"], bins =20)


if __name__ == '__main__':
    import sys
    sys.path.append('/Users/admin/Documents/GitHub/UGFAFAFA/code')
    from Tusharedata.daily import load
    from Tusharedata import lib
   
      # 获取数据
    df = load(code)
    lib.mas(df,[5])
    done(df,ma=5)