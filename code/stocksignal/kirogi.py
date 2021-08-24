#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import pandas as pd
from config import dataPath as root
from unit import isneedupdate

def signal(df,code,type, sps=[5,10,20,30,60]):
   
    path =  os.path.join(root, "stockdate/cvs/kirogi/"+type, code + '.csv')
    if isneedupdate(path) == False:
        print(code+"kirogi signal 不需要更新")
        return
    result = []
    for index, row in df.iterrows():
      
        dic = {}
        for sp in sps:
            speed = 0
            if index <= sp:
                bitem = df.iloc[0]
                eitem = df.iloc[index]
                speed = (eitem["close"]/bitem["close"])
            else:
                bitem = df.iloc[index - sp]
                eitem = df.iloc[index]
                speed = (eitem["close"]/bitem["close"])
        
            dic["speed"+str(sp)] = speed
        result.append(dic)

    tdf = pd.DataFrame(result)
    tdf["code"] = df["code"]
    tdf["date"] = df["date"]
    
    tdf.to_csv(path)
    print(code+"kirogi signal 更新完成")
