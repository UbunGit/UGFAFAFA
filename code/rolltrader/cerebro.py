#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import pandas as pd
import numpy as np
from pyecharts.components import Table
from pyecharts.options import ComponentTitleOpts
from pyecharts import options as opts
from pyecharts.charts import Line, Bar, Grid, Pie,Scatter
from .store import Store
from .free import bcomm,scomm
from .pycharts import someline
class Describe:

    def __init__(self,data,begincash):

        self.tradings = []
        self.trading = None
        self.data = data
        self.begincash = begincash
        # 最终收益
        self.endassets = None
        # 最大回撤
        self.minassets = {
            "begin":None,
            "end":None,
            "value":None
        }
        # 最大收益
        self.maxassets = {
            "begin":None,
            "end":None,
            "value":None
        }
        # 平均收益
        self.averageassets = 0

        # 开仓次数
        self.openpositions = 0
        # 清仓次数
        self.clearance = 0
        # 开仓 - 清仓 列表
        self.positions = None

        self.describe()
  
    def describe(self):

        def mapdescribe(item):
            
            if item["position"] >0:
                if self.trading == None:
                    self.trading = {}
                    self.trading["assets"] = item["assets"]
                    self.trading["bdate"] = item.name.strftime("%Y-%m-%d")

            else:
                if self.trading is not None:
                    shouyi = item["assets"]-self.trading["assets"]
                    shouyiv = shouyi/self.trading["assets"]
                    self.trading["sdate"] = item.name.strftime("%Y-%m-%d")
                    self.trading["assets_front"] = self.trading["assets"]
                    self.trading["assets"] = shouyi
                    self.trading["assetsv"] = shouyiv
                    self.tradings.append(self.trading)
                    self.trading = None

        
        self.data.apply(mapdescribe,axis=1) 
         #开仓次数
        self.openpositions = len(self.tradings)
        #清仓次数
        self.clearance = self.openpositions if self.trading == None else (self.openpositions-1)
        # 如果最后没有清仓，添加到列表
        if self.trading != None:
            shouyi = self.data.iloc[-1]["assets"]-self.trading["assets"]
            shouyiv = shouyi/self.trading["assets"]
            self.trading["sdate"] = self.data.iloc[-1].name.strftime("%Y-%m-%d")
            self.trading["assets"] = shouyi
            self.trading["assetsv"] = shouyiv
            self.tradings.append(self.trading)
        df = pd.DataFrame(self.tradings)
        # 最终收益
        endser = self.data.iloc[-1]
        self.endassets = ((endser["cash"]+(endser["position"]*endser["close"])) /self.begincash)-1
        # 最大回撤
        minassets = df[df["assetsv"] == df["assetsv"].min()].iloc[0]
        self.minassets = {
            "begin":minassets["bdate"],
            "end":minassets["sdate"],
            "value":minassets["assetsv"]
        }
        # 最大收益
        maxassets = df[df["assetsv"] == df["assetsv"].max()].iloc[0]
        self.maxassets = {
            "begin":maxassets["bdate"],
            "end":maxassets["sdate"],
            "value":maxassets["assetsv"]
        }
        #平均收益
        self.averageassets = df["assetsv"].mean()
       

        def cutassetsv(x):
 
            if x < -0.15:
                return "<-15%"
            elif x < -0.1:
                return "-(15~10)%"
            elif x < -0.5:
                return "-(10~5)%"
            elif x < -0:
                return "-(5~0)%"
            elif x < 0.5:
                return "0~5%"
            elif x < 1:
                return "5~10%"
            elif x < 1.5:
                return "10~15%"
            elif x < 2.0:
                return "15~20%"
            else:
                return ">20%"
                
        df["assetscut"] = df["assetsv"].apply(cutassetsv)
        print("最终收益{:.2f}".format(self.endassets))
        print("最大回撤{}".format(self.minassets))
        print("最大收益{}".format(self.maxassets))
        print("平均收益{:.2f}".format(self.averageassets))
        print("开仓次数{}".format(self.openpositions))
        print("清仓次数{}".format(self.clearance))
        self.positions = df

    # 结果分析图
    def table(self):

        table = Table()
        headers = ["项目", "数值", "开始时间", "结束时间"]
        rows = [
            ["最终收益", "{:.2f}%".format(self.endassets*100),"",""],
            ["交易次数", "{}".format(len(self.tradings)),"",""],
            ["平均收益", "{:.2f}%".format(self.averageassets*100),"",""],
            ["开仓次数", "{}".format(self.openpositions),"",""],
            ["清仓次数", "{}".format(self.clearance),"",""],
            ["手续费", "{:.2f}".format(self.data["scomm"].sum()+self.data["bcomm"].sum()),"",""],
            ["最大收益", "{:.2f}%".format(self.maxassets["value"]*100),self.maxassets["begin"],self.maxassets["end"]],
            ["最大回撤", "{:.2f}%".format(self.minassets["value"]*100),self.minassets["begin"],self.minassets["end"]],
        ]
        table.add(headers, rows)
        return table
    def pie(self):
        piedata = self.positions["assetscut"].value_counts(normalize=True, ascending=True )
        pie = Pie(init_opts=opts.InitOpts())
        [print(list(z)) for z in zip(piedata.index, piedata.values.round(2))],
        pie.add(
            "pie",
            data_pair = [list(z) for z in zip(piedata.index, piedata.values.round(2))],
            radius="40%",
            center=["50%", "50%"],
        )
        return pie

       

class Cerebro:
    '''
    回测中心
    '''

    def __init__(self):

        def strategy(data,cerebro):
            '''
            策略方法 固定返回四个数字，分别对应买入数量，买入价格，卖出数量，卖出价格
            '''
            return 0,0,0,0

        def log(msg):
            '''
            日志函数
            '''
            pass

        self.bcomm = bcomm  #买入手续费计算公式
        self.scomm = scomm  #买入手续费计算公式
        self.strategy = strategy # 策略
        self.cash = 10000 # 初始金额
        self.log = log
        
        self.data = list() # 股票列表 pa.DataForm
       
        self.result = None
        self.stores = {}
    
        # 开始回测
    
    def run(self):
        '''
        开始回测
        '''
        self.begincash = self.cash
        for index, row in self.data.iterrows():
            self.strategy(index,row,self)
  
    # 购买
    def buy(self,code,date,count,price,free = 0):
        if np.isnan(price):
            return False
        amount= count * price +free
        if self.cash < amount:
            return False
     
        self.cash = self.cash - amount
        store = self.store(code=code)
        store.buy(date=date,count=count,price=price,free=free)
    
    # 卖出
    def seller(self,code,date,count,price,free = 0.0):
        if np.isnan(price):
            return False
        store = self.store(code=code)
        if None == count:
                count = store.count
        if store.seller(date=date,count=count,price=price,free=free) == True:
            amount= count * price - free
           
            self.cash = self.cash + amount

    # 根据编码获取持仓对象
    def store(self,code):
        if code in self.stores.keys():
            store = self.stores[code]
        else:
            store = Store()
            self.stores[code] = store
        return self.stores[code]
    # 获取购买列表
    def buylist(self,codes=None):
        
        keys = []
        if None == codes:
            keys = self.stores.keys()
        else:
            for item in codes:
                if item in self.stores.keys():
                    keys.append(item)
        list = {}    
        for key in keys:
            store = self.stores[key]
            df = pd.DataFrame(store.blist)
            list[key] = df

        return list

   
     # 获取卖出列表
    # 获取卖出列表
    def selllist(self,codes=None):
        
        keys = []
        if None == codes:
            keys = self.stores.keys()
        else:
            for item in codes:
                if item in self.stores.keys():
                    keys.append(item)
        list = {}     
        for key in keys:
            store = self.stores[key]
            df = pd.DataFrame(store.slist)
            list[key] = df
        return list

    # 获取持仓区间
    def zonelist(self,codes=None):
        keys = []
        if None == codes:
            keys = self.stores.keys()
        else:
            for item in codes:
                if item in self.stores.keys():
                    keys.append(item)
        list = []    
        for key in keys:
            store = self.stores[key]
            df = pd.DataFrame(store.zones)
            list[key] = df
        return list

    # 获取收益曲线
    def chartEarnings(self,data):

        blist = self.buylist()
        slist = self.selllist()
        df = pd.DataFrame()
        for key in blist.keys():
            item = blist[key]
            item = item.rename(columns={'bdate':'date'})
            item = item.rename(columns={'bcount':'bcount'+key})
            item = item.rename(columns={'bprice':'bprice'+key})
            item = item.rename(columns={'bfree':'bfree'+key})
            item.set_index(["date"], inplace=True)
            # df = pd.concat([df, item], axis=0)
            df = pd.merge(left=item,right=df,how="outer",left_index=True,right_index=True)
        for key in slist.keys():
            item = slist[key]
            item = item.rename(columns={'sdate':'date'})
            item = item.rename(columns={'scount':'scount'+key})
            item = item.rename(columns={'sprice':'sprice'+key})
            item = item.rename(columns={'sfree':'sfree'+key})
            item.set_index(["date"], inplace=True)
            # df = pd.concat([df, item], axis=0)
            df = pd.merge(left=item,right=df,how="outer",left_index=True,right_index=True)
        
        df = pd.merge(left=data,right=df,how="outer",left_index=True,right_index=True)
        df = df.sort_index(axis=0)
        global g_cash
        g_cash = self.begincash
        df["cash"] = df.apply(earnings,axis = 1, args=(self.stores.keys(),))
        keys = ["cash"]
        for key in self.stores.keys():
            keys.append(key)
        for item in keys:
            df[item] = df[item]/(df[item].iloc[0])
        return someline(df,keys)
   

g_count = {}
g_cash = 10000
def earnings(data,codes=[]):
    global g_count,g_cash
    tcash = 0
    for code in codes:
        if code not in g_count.keys():
            g_count[code] = 0
    
        bcount = 0 if np.isnan(data["bcount"+code]) else data["bcount"+code]
        scount = 0 if np.isnan(data["scount"+code]) else data["scount"+code]
        bfree = 0 if np.isnan(data["bfree"+code]) else data["bfree"+code]
        sfree = 0 if np.isnan(data["sfree"+code]) else data["sfree"+code]
        bprice = 0 if np.isnan(data["bprice"+code]) else data["bprice"+code]
        sprice = 0 if np.isnan(data["sprice"+code]) else data["sprice"+code]

        g_count[code] =  g_count[code] + bcount - scount
        incash = sprice * scount -sfree
        outcash = bcount * bprice - bfree
        g_cash = g_cash + incash - outcash
        tcash = tcash + g_count[code]* data[code]
    return g_cash + tcash


import unittest
tindex = 1

class Test(unittest.TestCase):
    import sys
    
    sys.path.append('/Users/admin/Documents/GitHub/UGFAFAFA/code')

    @unittest.skipIf((tindex!=0 and tindex!=1), "reason")
    def test_base(self):
        print("begin test")
        from Tusharedata.daily import load as loaddata
        cerebro = Cerebro()
        df = loaddata(code="300059.SZ")
        df = df.rename(columns={'ts_code':'code'})
        df = df[df["date"]>"20200101"]
        df.index=pd.to_datetime(df.date)
        cerebro.data = df
        # cerebro.strategy = Strategy()

        def bcomm(amount):
            return amount*0.003
        cerebro.bcomm = bcomm
        cerebro.run()
if __name__ == "__main__":
    unittest.main()
    