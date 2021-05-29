#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys, json
import logging
import importlib
import pandas as pd
from .damrey import info as  damreyInfo
from .haikui import info as  haikuiInfo
from rolltrader.cerebro import Cerebro
from Tusharedata.daily import load


# 返回策略列表
def analyses():
    return  [
                damreyInfo(),
                haikuiInfo()
            ]

def log(msf):
    logging.debug(msf)

begin = "20190101"
end = ""
codes =["000333.SZ","600887.SH","000001.SZ","300059.SZ"]

class Analyse:

    def __init__(self,analyse = "damrey"):
        self.analyse = analyse

    def setup(
        self, 
        begin=begin,
        end = end,
        codes=codes,
        params=[
                    {
                        "name":"动能天数",
                        "key":"pct",
                        "value":"3"
                    },
                ]
        ):
        analyse = importlib.import_module("Analyse."+self.analyse)
        self.begin = begin
        self.end = end
        self.codes = codes
        self.params = params
        self.data = self.loaddata()
        analyse.signal(self.data,params=params)
        self.cerebro = Cerebro()
        self.cerebro.cash = 100000
        self.cerebro.strategy = analyse.strategy
        if self.begin:
            self.data = self.data[self.data.index>self.begin]
        if self.end:
            self.data = self.data[self.data.index<=self.end]
        self.cerebro.data = self.data
        self.cerebro.log = log
        self.cerebro.run()
        buylist = self.cerebro.buylist()
        print(buylist)
    
    def loaddata(self):
        df = None
        lastcode = None
        for item in self.codes:
            idf = load(code = item)
            idf = idf[idf["date"] > begin]
            idf.index= pd.to_datetime(idf["date"])
            idf = idf.rename(columns={'close':"close"+item})
            idf = idf.rename(columns={'open':"open"+item})
            if lastcode == None:
                df = idf[["close"+item,"open"+item]]
            else:
                df["close"+item] = idf["close"+item]
                df["open"+item] = idf["open"+item]
            lastcode = item
        return df


if __name__ == "__main__":
    
    analyse = Analyse()
    analyse.setup()
    