
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os, sys
import tushare as ts
ts.set_token("8631d6ca5dccdcd4b9e0eed7286611e40507c7eba04649c0eee71195")
sys.path.append("/Users/admin/Documents/stock/UGFAFAFA/code/")
import akshare as ak
from config import dataPath as root
from unit import isneedupdate

def filempath(path,name):
    path =  os.path.join(root, path, name + '.csv')
    return  path


def update_stock_daily(code):
    print("更新股票 code="+code)
    path =  os.path.join(root, "stockdate/cvs/stock", code + '.csv')
    if isneedupdate(path) == True:
        print("需要更新股票 code="+code)
        df = ts.pro_bar(ts_code=code, adj='qfq')
        if(df is None):
            raise Exception("error：下载股票数据失败")
        df = df.rename(columns={'trade_date':'date'})
        df = df.rename(columns={'ts_code':'code'})
        df = df.sort_values(by='date')
        df.to_csv(path)
    else:
        print("不需要更新股票 code="+code)

