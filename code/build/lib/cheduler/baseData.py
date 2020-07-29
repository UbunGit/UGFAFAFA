#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import tushare as ts
import numpy
import pandas
import time
from trade import shares,share
import logging

logging.basicConfig(level=logging.NOTSET)  # 设置日志级别  

formattime = (time.strftime('%Y-%m-%d',time.localtime(time.time())))

def updatebaseData(date):
    if date is None:
        date = formattime
    logging.info("加载股票列表 begin")
    l_shares = shares(date)
    fitters = l_shares.basics

    logging.info("加载股票列表 end",fitters)
    codes = numpy.array(fitters.code)
    names = numpy.array(fitters.name)
    sharlist = pandas.DataFrame()
    sharecodes = []
    sharenames = []
    logging.info("加载遍历股票列表，获取股票数据 begin")
    for i in range(len(codes)):
    # for i in range(1, 10):
        logging.info("{}/{}".format(i,len(codes)))
        try:
            temshare = share(codes[i])
            if temshare.cdata is not None and len(temshare.cdata)>1:
            
                data = temshare.appendmacd(temshare.cdata)
                data = data[data.date==date]
                if data.empty:
                    continue
                sharlist = sharlist.append(data)
                
                sharecodes.append(codes[i])
                sharenames.append(names[i])
                sharlist["code"]= sharecodes 
                sharlist["name"]= sharenames 
                sharlist.to_csv("~/share/tem/shares_"+date+".csv")
        except Exception as e:
            logging.error('except:', e)
          
    logging.info("{}/{}".format(i,len(codes)))
    logging.info("加载遍历股票列表，获取股票数据 end")            
    logging.info(sharlist)
        

if __name__ == '__main__':
    updatebaseData(None)
    
