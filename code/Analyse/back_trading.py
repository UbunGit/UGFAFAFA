#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import datetime  # For datetime objects

import pandas as pd

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

# 回测系统
def back_trading(data,begin=None, end = None, signal="signal"):
    print("begin... back_trading")
    print("data:")
    print(data)
    print("begin:"+str(begin))
    print("end:"+str(end))
    print("signal:"+signal)
    df = data
    if begin != None:
        df = df[df["date"]>int(begin)]
    if end != None:
        df == df[df["date"]<=int(end)]
    store = Store()
    print(store.orders)
    store.signal = signal
    print("back_trading --1")
    if df.empty:
        print("back_trading fitter data is empty ")
    else:
        df["assets"] = df.apply(tadding, axis=1,args=(store,))        
        orders = pd.DataFrame(store.orders)
        print("initial:10000")
        print("end:"+str(store.order))
        print("count:"+str(len(store.orders)))
        print("bandans:"+str(store.bandans))
        print("free:"+str(orders["free"].sum()))
        print(orders.info())
        print(df.info())
        orders["date"].astype('int64')
        df = pd.merge(df,orders,on='date',how='left')
        print(df.info()) 
        print("end... back_trading")
    return df

def tadding(data,store):
    
    if store.order != None:
        # sell
        if data[store.signal]<=0.5:
            order = store.order
            order["sdate"] = data["date"]
            smoney = order["count"]*data["close"]
            store.bandans = store.bandans + smoney*store.free
            order["smoney"] = smoney
            order["sprice"] = data["close"]
            order["free"] = smoney*(1-store.free)
            order["earnings"] = smoney-order["bmoney"]
            store.orders.append(order)
            # print(str(data["date"])+"seller ----")
            store.order = None
            
    else:
        if data[store.signal]>0.8:
            order = {}
            order["date"] = data["date"]
            count = int(store.bandans/(data["close"]*100)) *100
            bmoney = count*data["close"]
            store.bandans = store.bandans - bmoney
            order["bmoney"] = bmoney
            order["count"] = count
            order["bprice"] = data["close"]
            store.order = order
            # print(str(data["date"])+"buy ----")
        
    # print(str(data["date"])+"witting----")
    assets = store.bandans+ 0 if store.order == None else store.order["count"]*data["close"]
    return assets
        
# import sys
# sys.path.append('/Users/admin/Documents/GitHub/UGFAFAFA/code')
import chart.kline as kline
if __name__ == '__main__':

    df = pd.read_csv("/Users/admin/Documents/GitHub/UGFAFAFA/data/output/damrey/002028.SZ/result.csv")
    # print(df.info()) 
    # df = back_trading(df,begin="20210512",end="20210512")
    # print(df.info()) 
    # df = pd.read_csv("/Users/admin/Documents/GitHub/UGFAFAFA/data/output/damrey/002028.SZ/result.csv")
    # print(df.info()) 
    # df = back_trading(df,begin="20210512",end="20210512")
    # print(df.info()) 
    # kline.kline(df).render("/Users/admin/Documents/github/UGFAFAFA/data/tem/testanalyse.html")
    
    # # df = df[["date","assets","sdate","signal","count"]]
    # df.to_csv("/Users/admin/Documents/github/UGFAFAFA/data/tem/test.csv")