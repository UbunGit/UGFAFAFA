#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import pandas as pd
from config import dataPath as root
from stocksignal import kirogi
from stocksignal import damrey

# 更新股票日线数据
from tenacity import retry, stop_after_attempt
@retry(stop=stop_after_attempt(5))
def do_stock():
    from tusharedata import update_stock_daily
    stockpath =  os.path.join(root, "stockdate/cvs", "stock_basic" + '.csv')
    df = pd.read_csv(stockpath)
    try:
        for index, row in df.iterrows():
            print(row["code"]+ row["name"])
            update_stock_daily(row["code"])
            cpath =  os.path.join(root, "stockdate/cvs/stock", row["code"] + '.csv')
            cdf = pd.read_csv(cpath)
            cdf = cdf.sort_values(by='date',ignore_index=True)
            kirogi.signal(cdf,row["code"],"stock")
            damrey.signal(cdf,row["code"],"stock")
    except  Exception as e:
        print(e)

# 更新ETF日线数据
@retry(stop=stop_after_attempt(5))
def do_etf():
    from aksharedata import update_etf_daily
    etfpath = os.path.join(root, "stockdate/cvs", "etf_basic" + '.csv')
    df = pd.read_csv(etfpath)
    df = df.rename(columns={'symbol':'code'})
    try:
        for index, row in df.iterrows():
            print(row["code"])
            update_etf_daily(row["code"])
            cpath =  os.path.join(root, "stockdate/cvs/etf", row["code"] + '.csv')
            cdf = pd.read_csv(cpath)
            cdf = cdf.sort_values(by='date',ignore_index=True)
            kirogi.signal(cdf,row["code"],"etf")
            damrey.signal(cdf,row["code"],"etf")
    except  Exception as e:
        print(e)

do_stock()
do_etf()