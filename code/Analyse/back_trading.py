#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import datetime  # For datetime objects
import logging
import pandas as pd
logging.basicConfig(level=logging.WARN)  # 设置日志级别  
class Store:
    bandans = 10000
    free = 0.998
    store = 0
    orders = []
    order = None
    signal = "signal"

    def __init__(self): 
        self.bandans = 10000
        self.free = 0.998
        self.store = 0
        self.orders = []
        self.order = None
        self.signal = "signal"

def tadding(data,store):
    
    if store.order != None:
        # sell
        if data[store.signal] <= 0.6:
            print(str(data["date"])+"seller ----")
            order = store.order
            order["sdate"] = data["date"]
            smoney = order["count"]*data["close"]
            store.bandans = store.bandans + smoney*store.free
            order["smoney"] = smoney
            order["sprice"] = data["close"]
            order["free"] = smoney*(1-store.free)
            order["earnings"] = smoney-order["bmoney"]
            store.orders.append(order)
            store.order = None
            
    else:
        # bug
        if data[store.signal]>0.8:
            print(str(data["date"])+"buy ----")
            order = {}
            order["date"] = data["date"]
            count = int(store.bandans/(data["close"]*100)) *100
            bmoney = count*data["close"]
            store.bandans = store.bandans - bmoney
            order["bmoney"] = bmoney
            order["count"] = count
            order["bprice"] = data["close"]
            store.order = order
            
        
    print(str(data["date"])+"signal: "+str(data[store.signal]))
    assets = store.bandans+ 0 if store.order == None else store.order["count"]*data["close"]
    return assets
 

# 回测系统
def back_trading(data, begin=None, end = None, signal="signal"):

    logging.debug("begin... back_trading")
    logging.debug("data:")
    logging.debug(data.info())
   
    print("begin:"+str(begin))
    print("end:"+str(end))
    print("signal:"+signal)
    df = data
    if begin != None:
        df = df[df["date"] > str(begin)]
    if end != None:
        df = df[df["date"] <= int(end)]
    store = Store()
    store.signal = signal
  
    if df.empty:
        print("back_trading fitter data is empty ")
    else:
        assets = df.apply(tadding, axis=1,args=(store,))  
        df["assets"] = assets     
        orders = pd.DataFrame(store.orders)
        print("initial:10000")
        print("end:"+str(store.order))
        print("count:"+str(len(store.orders)))
        print("bandans:"+str(store.bandans))
        print("free:"+str(orders["free"].sum()))
      
        orders["date"].astype('int64')
        df = pd.merge(df,orders,on='date',how='left')
        
        print(df[["date","assets"]])  
        print("end... back_trading")
    return df

       

if __name__ == '__main__':

    import sys
    sys.path.append('/Users/admin/Documents/GitHub/UGFAFAFA/code')
    import chart.kline as kline

    df = pd.read_csv("/Users/admin/Documents/github/UGFAFAFA/data/tem/test.csv")
    print(df.info()) 
    df = back_trading(df)
    kline.kline(df).render("/Users/admin/Documents/github/UGFAFAFA/data/tem/line.html")
    
    # # df = df[["date","assets","sdate","signal","count"]]
    # df.to_csv("/Users/admin/Documents/github/UGFAFAFA/data/tem/test.csv")