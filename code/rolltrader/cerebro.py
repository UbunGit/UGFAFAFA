#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import pandas as pd
from pyecharts.components import Table
from pyecharts.options import ComponentTitleOpts
from pyecharts import options as opts
from pyecharts.charts import Line, Bar, Grid, Pie,Scatter
class Describe:

    def __init__(self,data):
        self.tradings = []
        self.trading = None

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

        self.describe(data)
  
    def describe(self,data):

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
                    self.trading["assets"] = shouyi
                    self.trading["assetsv"] = shouyiv
                    self.tradings.append(self.trading)
                    self.trading = None

        data.apply(mapdescribe,axis=1) 
        # 如果最后没有清仓，添加到列表
        if self.trading != None:
            self.tradings.append(self.trading)
        df = pd.DataFrame(self.tradings)
        # 最终收益
        endser = data.iloc[-1]
        self.endassets = (endser["cash"]+(endser["position"]*endser["close"])) /10000
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
        #开仓次数
        self.openpositions = len(self.tradings)
        #清仓次数
        self.clearance = self.openpositions if self.trading == None else (self.openpositions-1)

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
    def pycharts(self):
        table = Table()
        headers = ["项目", "数值", "开始时间", "结束时间"]
        rows = [
            ["最终收益", "{:.2f}%".format(self.endassets*100),"",""],
            ["交易次数", "{}".format(len(self.tradings)),"",""],
            ["平均收益", "{:.2f}%".format(self.averageassets*100),"",""],
            ["开仓次数", "{}".format(self.openpositions),"",""],
            ["清仓次数", "{}".format(self.clearance),"",""],
            ["最大收益", "{:.2f}%".format(self.maxassets["value"]*100),self.maxassets["begin"],self.maxassets["end"]],
            ["最大回撤", "{:.2f}%".format(self.minassets["value"]*100),self.minassets["begin"],self.minassets["end"]],
        ]
        table.add(headers, rows)

        # piedata = pd.value_counts(self.positions["assetscut"]) 
        # pie = Pie(init_opts=opts.InitOpts())
        # pie.add(
        #     [list(z) for z in zip(piedata.index, piedata.values.round(2))],
        #     radius="40%",
        #     center=["50%", "50%"],
        # )

        # grid = Grid(init_opts=opts.InitOpts())
        # grid.add(
        #     table, grid_opts=opts.GridOpts(pos_right="50%"), is_control_axis_index=True
        # )
        # grid.add(pie, grid_opts=opts.GridOpts(pos_left="50%"), is_control_axis_index=True)
        return table
 
       

class Cerebro:
    '''
    回测中心
    '''

    def __init__(self):

        
        def bcomm(amount):
            '''
            买入手续费
            ''' 
            yongjin = 5 if amount*0.003<5 else amount*0.003
            yinhua = 0
            guohu = amount*0.0006
            return yongjin+yinhua+guohu

        def scomm(amount):
            '''
            计算买入手续费
            ''' 
            yongjin = 5 if amount*0.003<5 else amount*0.003
            yinhua =  amount*0.001
            return yongjin+yinhua
            return 0

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

        self.position = 0 #持仓
        

        self.result = None

         
    def run(self):
        '''
        开始回测
        '''
        def runapply(data,cerebro):
          
            order = {}
            order["bcomm"] = 0
            order["scomm"] = 0
            order["berror"] = None
            order["serror"] = None
            order["bcount"], order["bprice"], order["scount"], order["sprice"] = self.strategy(data,cerebro)

            # 卖出逻辑
            if(order["scount"]*order["sprice"]):
                amount = order["scount"]*order["sprice"]
                free = self.scomm(amount)
                if self.position >= order["scount"]:
                    self.cash = self.cash + (amount - free)
                    self.position = self.position - order["scount"]
                    
                else:
                    order["serror"] = "持仓不足"
                    # 持仓不足
                    order["scount"] = 0
                    order["sprice"] = 0
                    order["scomm"] = 0

                order["scomm"] = self.scomm(order["scount"]*order["sprice"])
            # 买入逻辑

            if(order["bcount"]*order["bprice"]):
                amount = order["bcount"]*order["bprice"]
                free = self.bcomm(amount)
                if(self.cash - amount - free)<=0:
                    # 余额不足
                    order["berror"] = "余额不足"
                    order["bcount"] = 0
                    order["bprice"] = 0
                    order["bcomm"] = 0
                else:
                    order["bcomm"] = free
                    self.cash = self.cash - amount - free
                    self.position = self.position + order["bcount"]
            order["cash"] = self.cash
            order["position"] = self.position
            # 计算资产
 
            order["assets"] = round((data["close"]*order["position"])+order["cash"],2)
            self.log(order)
            return order

        df = pd.DataFrame()
        orders = self.data.apply(runapply, axis=1,args=(self,))
        df = pd.DataFrame(orders.values.tolist())
        df.index= pd.to_datetime(orders.index)
        self.result = self.data.join(df)
        
        self.describe = Describe(self.result)


    def pycharts(self,name):
        '''
        画图
        '''
        from .pycharts import page
        repage = page(self.result,name)
        deschart = self.describe.pycharts()
        repage.add(
            deschart
        )
        return repage
    
    





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
    