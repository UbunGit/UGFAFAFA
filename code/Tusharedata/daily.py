#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 目的
# 创建股票前n天的收盘集合与后m天的收盘价
import os
import numpy, logging
import pandas
import time,datetime
import talib as tl
import tushare as ts
from matplotlib import pyplot as plt 

import logging
from .db import session, DataCache
from config import dataPath as root
ts.set_token("8631d6ca5dccdcd4b9e0eed7286611e40507c7eba04649c0eee71195")
logging.basicConfig(level=logging.DEBUG)  # 设置日志级别
datapath = root

def filempath(scode):
    return  os.path.join(datapath,"tushare",scode+'.csv')

def cacheKey(code):
    return "daily." + code

# 获取本地数据
def sd_local(code="000001.SZ"):
    _code = code
    datafile = filempath(_code)
    if os.path.exists(datafile):
        temdata = pandas.read_csv(datafile ,dtype={"date":"string"}, index_col=0)
        temdata = temdata.sort_values(by='date')
        if len(temdata)>0:
            return temdata
        else:
            raise Exception("temdata id empty")
    else:
        raise Exception("datafile not exists!", datafile)

# 从网络加载股票数据
def load(code="000001.SZ"):
    _code = code.lower()
    try:
        logging.debug(">>>>> load DataCache")
        input = session.query(DataCache).filter_by(key = cacheKey(_code)).first()
        logging.debug(">>>>> load DataCache end")
        datafile = filempath(scode=_code)

        # 1 如果没有数据记录，或文件不存在 下载
        if input == None or os.path.exists(datafile)==False:
            logging.debug(">>>>> 如果没有数据记录，或文件不存在 下载")
            data = ts.pro_bar(ts_code=_code, adj='qfq', ma=[5,10,20,30])
            if(data is None):
                raise Exception("error：下载股票数据失败")
            data = data.rename(columns={'trade_date':'date'})
            sd_save(_code,data)
            logging.debug("更新完成")
        else:
            # 2 如果当前时间<16点 判断更新时间是否>昨天16点 如果大于不更新
            # 3 如果当前时间>16点 判断更新时间是否>今天16点，如果大于不更新
            now = time.localtime(time.time())
            ctime = datetime.datetime.fromtimestamp(float(input.value))
            jtime = None
            if now.tm_hour<=16:
                jtime = datetime.datetime(now.tm_year, now.tm_mon, now.tm_mday-1, 16, 00)
            else:
                jtime = datetime.datetime(now.tm_year, now.tm_mon, now.tm_mday, 16, 00)
            if ctime <= jtime:
                logging.debug(">>>>> 更新...")
                data = ts.pro_bar(ts_code=_code, adj='qfq')
                if(data is None):
                    raise Exception("error：下载股票数据失败")
                data = data.rename(columns={'trade_date':'date'})
                data.to_csv(datafile)
                input.value = time.time()
                session.add(input)
                session.commit()
                logging.debug("更新完成")

        data = sd_local( code = _code)
        data = data.sort_values(by='date')
        logging.debug(">>>>> load return data")
        return data

    except:
        logging.error('load except:', )
        raise Exception()

# 保存数据到本地
def sd_save(code, data):
    _code = code
    datafile = filempath(scode=_code)
    data.to_csv(datafile)
    logging.debug(">>>>> sd_save to_csv")
    datacache = DataCache()
    datacache.key = cacheKey(_code)
    datacache.value = time.time() 
    session.add(datacache)
    logging.debug(">>>>> sd_save session")
    session.commit()
    logging.debug(">>>>> sd_save commit")

import unittest


class TestStores(unittest.TestCase):
    import sys
    sys.path.append('../../code')
    code = '300059.SZ'


    def setUp(self):
        logging.info ("setup...")

   
    def test_load(self):
        logging.info("test_load.")
        try:
            data = load("000001.SZ")
            print(data)
          
        except Exception as err:
            logging.error (err)
    

if __name__ == '__main__':
    unittest.main()