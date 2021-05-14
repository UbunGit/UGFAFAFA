#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os,sys
import pandas as pd
import tushare as ts
from .db import session, DataCache
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

# 搜索股票列表
def search(keyword):
    if os.path.exists(filepath)==False:
        return None
    df = pd.read_csv(filepath , index_col=0).rename(columns={'ts_code':'code'})
    return df[df["name"].str.contains(keyword) | df["code"].str.contains(keyword)].to_json(orient='records',force_ascii=False)

# 下载数据
def reload():
    data = ts.pro_api().query('stock_basic')
    if data is None:
        return None
    else:
        data.to_csv(filepath)
        return data
       
        
