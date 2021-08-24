
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os, sys


sys.path.append("/Users/admin/Documents/stock/UGFAFAFA/code/")
import akshare as ak
from config import dataPath as root
from unit import isneedupdate

def filempath(path,name):
    path =  os.path.join(root, path, name + '.csv')
    return  path


def update_etf_daily(code):
    print("更新ETF code="+code)
    path =  os.path.join(root, "stockdate/cvs/etf", code + '.csv')
    if isneedupdate(path) == True:
        print("需要更新ETF code="+code)
        df = ak.fund_etf_hist_sina(symbol=code)
        df = df.sort_values(by='date')
        df.to_csv(path)
    else:
        print("不需要更新ETF code="+code)
if __name__ == '__main__':
    update_etf_daily("sz169103")