#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy

import logging
import os, json
import pandas as pd
import numpy as np
import sys

sys.path.append("./code") 

from trade import share
from trade import trade
from trade import Stores
from trade import ShareData


if __name__ == '__main__':

    logging.info("根据macd值买入优化v1.0.0 2020.7.14")
    logging.info("args:%s",sys.argv)
    amount = '10000'
    start = '20200707'
    end = '20200907'
    tcode = '300022.SZ'
    if len(sys.argv)>1 and len(sys.argv[1])>0:
        indata = json.loads(sys.argv[1])
        if "start" in indata:
            start=indata["start"]
        if "end" in indata:
            end=indata["end"]
        if "amount" in indata:
            amount=indata["amount"]
        if "tcode" in indata:
            tcode=indata["tcode"]
        
    logging.info("begin tcode:%s amount:%s start:%s end:%s",tcode,amount,start,end)
 
    share = share(tcode)
    data = share.appendmacd(share.cdata)
    data = share.appendma(data,5)

    data_fecha = data[data.date>=start]
    selectData =  data_fecha[data_fecha.date<=end]
    logging.info("selectData:\n%s",selectData)

    firstData = selectData.iloc[0]
    stores = Stores()
    stores.balance = 10000
    lastData = None
    for i in range(len(selectData)):
        temdata = selectData.iloc[i]
        lastData = temdata
        share = ShareData()
        share.__dict__.update(temdata.to_dict())
        inScale = 0.95-len(stores.online)*0.05
        # if(share.ma5>share.open):
        stores.buy(share,inScale= inScale)
        # else:
        #     logging.debug("share.ma30>share.open")
        # if(share.ma5<share.open):
        stores.seller(share)
        # else:
        #     logging.debug("share.ma30<share.open")
       
    

    res = pd.DataFrame(map(lambda x:x.__dict__,stores.line), columns=('num', 'bdate', 'sdate', 'bprice', 'sprice', 'isSeller', 'inday', 'fee'), index=map(lambda x:x.id,stores.line))
    print(res)
    logging.debug("余额：{}".format(stores.balance))
    logging.debug("持股：{}".format(stores.assets))
    logging.debug("交易次数：{}".format(len(stores.line)))
    logging.debug("未卖出笔数：{}".format(len(stores.online))) 
    logging.debug("结余：{}".format(stores.assets*lastData.close +stores.balance))
        

 


    