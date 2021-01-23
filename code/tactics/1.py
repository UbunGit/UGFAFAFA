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
from trade import ShareData,StoreData

def test():
    print("test is run")

def buy(share, stores, inScale=0.95):
    price = share.close    
    if len(stores.online)>0:
        price = minPrice(stores)*inScale
        price = min([share.close,price])
    bcount = buyCount(price, stores.money)
    totalPrice =  price*bcount

    if price<share.close:
        logging.debug('''时间{} 买入失败 买入价{:.3f} 最低价{} 比例{} online{}'''.format(share.date,price,share.low,inScale,len(stores.online)))
        return
    
    if price<share.ma30:
        logging.debug('''时间{} 买入失败 买入价{:.3f} MA30{} 比例{} online{}'''.format(share.date,price,share.ma30,inScale,len(stores.online)))
        return
    if stores.balance > totalPrice:
        store = StoreData()
        store.id = len(stores.line)
        store.num = bcount
        store.bdate = share.date
        store.bprice = price
        store.inday = 0
        stores.buy(store)
        share.B = store.bprice
        
    else:
        logging.debug("余额不足:{}".format(stores.balance))

def seller(share,stores,fee=10.00,outScale=1.10):
    for item in stores.online:
        item.inday = item.inday+1
        sellerPrice = item.bprice * outScale
        if sellerPrice < share.high:
            item.sdate = share.date
            item.sprice = sellerPrice
            item.isSeller = True
            item.fee = fee
            stores.seller(item)
            share.S = item.sprice
            logging.debug("卖出 id{} 价格：{}".format(item.id,item.sprice))
            
        else:
            logging.debug("卖出失败 id{}".format(item.id))

def buyCount(price, money):
        return int(money/(price*100))*100

def minPrice(stores):
        list = []
        for item in stores.online:
            list.append(item.bprice)
        return min(list)

if __name__ == '__main__':

    logging.info("根据macd值买入优化v1.0.0 2020.7.14")
    logging.info("args:%s",sys.argv)
    amount = '10000'
    start = '20200507'
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
    data = share.appendma(data,30)

    data_fecha = data[data.date>=start]
    selectData =  data_fecha[data_fecha.date<=end]
    logging.info("selectData:\n%s",selectData)

    firstData = selectData.iloc[0]
    stores = Stores()
    stores.balance = 10000
    lastData = None
    shares = []
    for i in range(len(selectData)):
        temdata = selectData.iloc[i]
        lastData = temdata
        share = ShareData()
        share.__dict__.update(temdata.to_dict())
        inScale = 0.95-len(stores.online)*0.05

        buy(share,stores,inScale=inScale)
        seller(share,stores)
        shares.append(share)
  
    res = pd.DataFrame(map(lambda x:x.__dict__,stores.line), columns=('num', 'bdate', 'sdate', 'bprice', 'sprice', 'isSeller', 'inday', 'fee'), index=map(lambda x:x.id,stores.line))
    print(res)
    logging.debug("余额：{}".format(stores.balance))
    logging.debug("持股：{}".format(stores.assets))
    logging.debug("交易次数：{}".format(len(stores.line)))
    logging.debug("未卖出笔数：{}".format(len(stores.online))) 
    logging.debug("结余：{}".format(stores.assets*lastData.close +stores.balance))

    spd = pd.DataFrame(map(lambda x:x.__dict__,shares), columns=('date','open', 'high', 'low', 'close', 'vol', 'B', 'S'))
    print(spd)
    path = '~/share/tem/tem.csv'
    spd.to_csv(path)
        

 


    