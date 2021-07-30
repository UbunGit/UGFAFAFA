#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os,sys
from datetime import datetime
sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code/")
import akshare as ak
from Tusharedata import db
from config import dataPath as root

def filempath(name):
    return  os.path.join(root,"akshare",name+'.csv')

def update(isNeed=False):
    last = db.ETFBasic().last()
    overdue = False # 数据是否过期
    if last== None:
        overdue = True
    else:  
        # 比较时间超过7天更新一次  
        enddata = last.changeTime
        overdue = (datetime.now()-enddata).seconds > 7*24*60*60

    if (overdue or isNeed)==True:
        print ("更新ETF列表")
        df = ak.fund_em_etf_fund_daily()
        df = df.rename(columns={'基金代码':'code','基金简称':'name'})
        datas = df.to_dict(orient="records")
        db.ETFBasic().to_db(datas=datas)
    else:
        print ("ETF列表无需更新")


