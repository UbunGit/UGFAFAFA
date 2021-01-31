#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import os, json, logging
sys.path.append("..") 

from flask_socketio import SocketIO,send,emit  
import pandas as pd
import numpy as np

from trade import share
from trade import Stores
from trade import ShareData,StoreData
from unit import buyCount,TError


stores = None
inScale = 0.95
outScale = 1.10
money = 20000

def setup(param={
            'code': "300022.SZ",
            'begin': '20200107',
            'end': '20210607',
            'money': 20000
            }):
    print(param)
    global code
    global begin 
    global end
    global money
    global inScale
    global inScale
    global outScale
    global stores
    global acount
    
    money = 20000
    acount = 2000
    code = param.get('code')
    begin = param.get('begin')
    end = param.get('end')

    if param.__contains__("money"):
        money = float(param.get('money'))
    if param.__contains__("acount"):
        acount = float(param.get('acount'))
    
    if param.__contains__("inScale"):
        inScale = float(param.get('inScale'))
    if param.__contains__("outScale"):
        outScale = float(param.get('outScale'))

    stores = Stores(balance = money)
    spd = share(code)
    if spd.cdata is None:
        return []
    list = spd.appendma(data=spd.cdata,ma=5)
    list = spd.appendma(data=list,ma=10)
    list = spd.appendma(data=list,ma=20)
    
    if begin != None:
        list = list[list.date>=begin]
    if end != None:
        list = list[list.date<=end]
    
    shares = json.loads(list.to_json(orient='records'))

    logging.info(
        '''
        setup
        余额：{}
        持仓：{}
        持仓记录：{}
        代码：{}
        ''' .format(
            stores.balance,
            stores.assets,
            stores.online,
            code
        )
    )
    return shares

def buy(share):
    try:
        price = share.get('close')
        if len(stores.online)>0:
            scalePrice = stores.minPrice()*inScale
            price = min([scalePrice,price])
        if price<share.get('close'):
            raise TError('''买入价{:.3f}小于收盘价{:.3f}'''.format(price,share.get('close')))

        if share.get('ma10')>share.get('ma5'):
            raise TError('''ma10{:.3f}大于ma5 {:.3f}'''.format(share.get('ma10'),share.get('ma5')))

        bcount = buyCount(price, acount)
        totalPrice =  price*bcount
        if stores.balance < totalPrice:
            raise TError('''余额不足''')
        store = {
            "num":bcount,
            "bdate":share.get("date"),
            "bprice":price,
            "inday":0
        }
        stores.buy(store)

    except TError as err:
        share["B"]={
            "isBuy":False,
            "msg":err.msg
        }
    else:

        share["B"]={
            "isBuy":True,
            "data":store
        }
        print("+++++++++{}".format(store["id"]) )
        
    finally:
        return share

def seller(share):
    try:
        if len(stores.online) == 0:
            raise TError('''持仓为空''')
        if share.get('ma10')<=share.get('ma5'):
            raise TError('''ma10 {:.3f}小于ma5 {:.3f}'''.format(share.get('ma10'),share.get('ma5')))
        sellers = []

        for item in stores.online:
            item["inday"]= item.get("inday") +1
            sellerPrice = item.get("bprice") * outScale
      
            if sellerPrice < share.get('high'):
                item["sdate"] = share.get("date")
                item["sprice"] = max([sellerPrice,share.get('close')])
                item["isSeller"] = True
                item["fee"] = 10.00
                stores.seller(item)
                sellers.append(item)
        if len(sellers)==0:
            raise TError('''没有符合条件的卖出单''')

    except TError as err:
        share["S"]={
            "isSeller":False,
            "msg":err.msg
        }
  
    else:
        
        share["S"]={
            "isSeller":True,
            "data":sellers
        }
        
    finally:
        return share

def summary(share):
    share["blance"]= stores.balance
    share["assets"] = stores.assets
    share["summary"] = (stores.assets*share.get("close")) + stores.balance
    share["online"]= stores.online
    share["money"]= money
    return share

def finesh():
    return {
       "line":stores.line 
    }

if __name__ == '__main__':
    
    shares = setup({'code': '300022.sz', 'begin': '20210101', 'end': '20210607', 'money': '20000', 'inScale': '0.98', 'outScale': '1.10'})
    for item in shares:

        data = seller(item)
        data = buy(data)
        data = summary(data)
        print('----------------') 
    print(stores.line)



