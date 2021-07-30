#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os,sys
from datetime import datetime
import pandas as pd
import tushare as ts
from Tusharedata import db
from config import dataPath as root

ts.set_token("8631d6ca5dccdcd4b9e0eed7286611e40507c7eba04649c0eee71195")
filepath = os.path.join(root,"tushare", 'base.csv')
key = "tusharedata.base"

# 最后更新时间
def updateTime():
    input = session.query(DataCache).filter_by(key = key).first()
    if input != None:
        return input.value
    else:
        return None


# 下载数据
def reload():
    data = ts.pro_api().query('stock_basic')
    if data is None:
        return None
    else:
        data.to_csv(filepath)
        return data
# 更新数据        
def update(isNeed=False):
    last = db.StockBasic().last()
    overdue = False # 数据是否过期
    if last== None:
        overdue = True
    else:  
        # 比较时间超过7天更新一次  
        enddata = last.changeTime
        overdue = (datetime.now()-enddata).seconds > 7*24*60*60

    if (overdue or isNeed)==True:
        print ("更新股票列表")
        df = ts.pro_api().query('stock_basic')
        df = df.rename(columns={'ts_code':'code'})
        datas = df.to_dict(orient="records")
        db.StockBasic().to_db(datas=datas)
        print ("股票列表更新完毕")
    else:
        print ("股票列表无需更新")





        
