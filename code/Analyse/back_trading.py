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

# 回测系统
def back_trading(data,signal):
    store = Store()
    store.signal = signal
    print(data)
    data["assets"] = data.apply(tadding,axis=1,args=(store,))
    orders = pd.DataFrame(store.orders)
    print("初始金额 10000")
    print("结余持仓："+str(store.order))
    print("交易笔数："+str(len(store.orders)))
    print("结余："+str(store.bandans))
    print("手续费总和："+str(orders["free"].sum()))
    print(orders)
    df = pd.merge(data,orders,how='left')
    print(df) 
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
                print(str(data["date"])+"seller ----")
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
                print(str(data["date"])+"buy ----")
            
        print(str(data["date"])+"witting----")
        assets = store.bandans+ 0 if store.order == None else store.order["count"]*data["close"]
        return assets
        


if __name__ == '__main__':
    data = pd.read_csv("/Users/admin/Documents/GitHub/UGFAFAFA/data/output/damrey/000001.SZ/result.csv")
    back_trading(data,"signal")
    data.to_csv("/Users/admin/Documents/GitHub/UGFAFAFA/data/tem/test.csv")