#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import pandas as pd
import talib as tl
from config import dataPath as root
from unit import isneedupdate


  

def signal(df,code,type, mas=[5,10,20,30,60]):
       
    path =  os.path.join(root, "stockdate/cvs/damrey/"+type, code + '.csv')
    if isneedupdate(path) == False:
        print(code+"kirogi signal 不需要更新")
        return
    tdf = pd.DataFrame()
    tdf["code"] = df["code"]
    tdf["date"] = df["date"]
    for ma in mas:
        key = "ma"+str(ma)
        tdf[key]= tl.MA(df['close'],timeperiod=int(ma))
    tdf.to_csv(path)
    print(code+"damrey signal 更新完成")