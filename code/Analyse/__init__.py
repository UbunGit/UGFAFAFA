#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys, json,time,datetime
sys.path.append('/Users/admin/Documents/GitHub/UGFAFAFA/code')
import logging
import importlib
import pandas as pd
# from datetime import datetime
from Analyse.damrey import info as  damreyInfo
from Analyse.haikui import info as  haikuiInfo
from rolltrader.cerebro import Cerebro
from Tusharedata.daily import load
from Analyse.catch import AnalyseBSRecords as BSRecords
from Analyse.catch import AnalyseZoneRecords as ZoneRecords
from Analyse.catch import AnalyseCache as Cache
from Analyse.catch import engine ,session
from Analyse.charts import earningsLine
from Analyse.charts import kline


# 返回策略列表
def analyses():
    return  [
                damreyInfo(),
                haikuiInfo()
            ]

def log(msf):
    logging.debug(msf)

begin = "20190101"
end = datetime.date.today().strftime('%Y%m%d')
codes =["000333.SZ","600887.SH","000001.SZ","300059.SZ"]

class Analyse:

    def __init__(self,analyse = "damrey"):
        self.name = analyse

    def setup(
        self, 
        begin=begin,
        end = end,
        codes=codes,
        parameter=[
                    {
                        "name":"动能天数",
                        "key":"pct",
                        "value":"3"
                    },
                ]
        ):
        analyse = importlib.import_module("Analyse."+self.name)
        self.begin = begin
        self.end = end
        self.codes = codes
        self.parameter = parameter
        self.data = self.loaddata()
        analyse.signal(self.data,parameter=parameter)
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
            idf = idf[idf["date"] > self.begin]
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

    def catch(self):
        
        # 保存结果
        records = Cache()
        records.codes = self.codes
        records.name = self.name
        records.parameter = self.parameter
        records.begin = datetime.datetime.strptime(self.begin,'%Y%m%d')
        records.end = datetime.datetime.strptime(self.end,'%Y%m%d')
        records.create()
        # 删除该id下bs与持仓的记录
        BSRecords().delete(cache_id=records.id)
        ZoneRecords().delete(cache_id=records.id)
        # 保存买卖记录
        list = self.cerebro.buylist()
        for key in list:
            df = list[key]
            df = df.rename(columns={'bdate':'date'})
            df = df.rename(columns={'bcount':'count'})
            df = df.rename(columns={'bprice':'price'})
            df = df.rename(columns={'bfree':'free'})
            df["cache_id"] = records.id
            df["code"] = key
            df["type"] = 1
            df.to_sql(name='analyse_bs_records', con=engine,if_exists='append',index=False)
        list = self.cerebro.selllist()
        for key in list:
            df = list[key]
            df = df.rename(columns={'sdate':'date'})
            df = df.rename(columns={'scount':'count'})
            df = df.rename(columns={'sprice':'price'})
            df = df.rename(columns={'sfree':'free'})
            df["cache_id"] = records.id
            df["code"] = key
            df["type"] = 2
            df.to_sql(name='analyse_bs_records', con=engine,if_exists='append',index=False)
        # 保存持仓区间
        df = self.cerebro.zonelist()
        df["cache_id"] = records.id
        df.to_sql(name='analyse_zone_records', con=engine,if_exists='append',index=False)
        return records.id
    
    def makecharts(self,id):
        # 收益对比图
        earningsdf = self.cerebro.chartEarnings(self.data)
        earningskey = list()
        for code in self.codes:
            earningsdf = earningsdf.rename(columns={"close"+code:code})
            earningskey.append(code)
        earningskey.append("cash")
        earningsline = earningsLine(earningsdf,keys=earningskey)
        print(earningsline.render("../data/analyse/chart/earnings_"+str(id)+".html"))
        # k线图
        klines = []
        for code in self.codes:
            df = load(code = code)
            df = df[df["date"] > self.begin]
            df.index= pd.to_datetime(df["date"])
            buy = BSRecords().search(cache_id=id,code=code,type=1)
            bdf = pd.DataFrame([x.__dict__ for x in buy]).drop('_sa_instance_state', 1) 
            bdf.index= pd.to_datetime(bdf["date"])

            sell = BSRecords().search(cache_id=id,code=code,type=2)
            sdf = pd.DataFrame([x.__dict__ for x in sell]).drop('_sa_instance_state', 1)
            sdf.index= pd.to_datetime(sdf["date"])

            zone = ZoneRecords().search(cache_id=id,code=code)
            zonedf = pd.DataFrame([x.__dict__ for x in zone]).drop('_sa_instance_state', 1).dropna(axis=0,how='any')

            kchart = kline(df,buy=bdf,sell = sdf,zone=zonedf)
            klines.append(kchart)
            kchart.render("../data/analyse/chart/klines_"+code+str(id)+".html")
        


if __name__ == "__main__":

    analyse = Analyse()
    analyse.setup()
    analyseid = analyse.catch()
    analyse.makecharts(analyseid)
    