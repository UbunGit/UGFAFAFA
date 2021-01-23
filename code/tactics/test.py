#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import os, json
sys.path.append("./code") 

import pandas as pd
import numpy as np

from trade import share
from trade import Stores
from trade import ShareData,StoreData

def buyCount(price, money):
    return int(money/(price*100))*100

class TError(BaseException):
    def __init__(self, arg):
        self.msg = arg


stores = Stores()
inScale = 0.95
outScale = 0.10
money = 10000

def setup(param):
    global code,begin ,end,money,inScale,inScale,outScale
    
    code = param.get('code')
    begin = param.get('begin')
    end = param.get('end')

    if param.__contains__("money"):
        money = param.get('money')
    if param.__contains__("inScale"):
        inScale = param.get('inScale')
    if param.__contains__("outScale"):
        outScale = param.get('outScale')

    spd = share(code)
    list = spd.cdata
    if begin != None:
        list = list[list.date>=begin]
    if end != None:
        list = list[list.date<=end]
    stores.balance = money
    shares = json.loads(list.to_json(orient='records'))
    return shares

def buy(share):
    try:
        price = share.get('close')
        if len(stores.online)>0:
            scalePrice = stores.minPrice()*inScale
            price = min([scalePrice,price])
        if price<share.get('close'):
            raise TError('''买入价{:.3f}小于收盘价{:.3f}'''.format(price,share.get('close')))

        bcount = buyCount(price, 2000)
        totalPrice =  price*bcount
        if stores.balance < totalPrice:
            raise TError('''余额不足''')
        store = {
            "id":stores.next(),
            "num":bcount,
            "bdate":share.get("date"),
            "bprice":price,
            "inday":0
        }
        stores.buy(store)

    except TError as err:
        share["B"]={
            "isbuy":False,
            "msg":err.msg
        }
    else:
        # share["blance"]= stores.balance
        # share["assets"] = stores.assets
        share["S"]={
            "isbuy":True,
            "data":store
        }
        
    finally:
        return share
    




