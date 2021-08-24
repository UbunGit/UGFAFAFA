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


def update_etf_basic():
    print("更新ETF列表")
    path = os.path.join(root, "stockdate/cvs", "etf_basic" + '.csv')
    if isneedupdate(path)== True:
        print("ETF列表需要更新")
        df = ak.fund_etf_category_sina(symbol="ETF基金")
        df = df.rename(columns={'基金代码': 'code', '基金简称': 'name'})
        df.to_csv(path)
    else:
        print("ETF列表不需要更新")
