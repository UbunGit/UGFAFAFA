#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os, sys
from datetime import datetime
import pandas as pd
import tushare as ts
from config import dataPath as root
from unit import isneedupdate
ts.set_token("8631d6ca5dccdcd4b9e0eed7286611e40507c7eba04649c0eee71195")
filepath = os.path.join(root, "tushare", 'base.csv')
key = "tusharedata.base"


# 更新数据
def update_stock_basic(isNeed=False):

    print("更新股票列表")
    path =  os.path.join(root, "stockdate/cvs", "stock_basic" + '.csv')
    if isneedupdate(path) == True:
        print("股票列表需要更新")
        df = ts.pro_api().query('stock_basic')
        df = df.rename(columns={'ts_code': 'code'})
        df.to_csv(path)
    else:
        print("股票列表不需要更新")
