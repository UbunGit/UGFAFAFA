#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from trade import share
from trade import trade
import numpy
import sys
import logging
import os
import pandas as pd
import numpy as np


logging.basicConfig(level=logging.NOTSET)  # 设置日志级别  

# 根据macd值买入优化v1.0.0 2020.7.14
# 步骤：
# 1.获取 MACD DEA，DIFF
# 2.如果 MACD>0 --其实也就是20日均线开始向上掉头，判断是否可以买入
# 3.以第一次买入价制定买卖价格11个档位 -- 30日均线 向上5个，向下五个 各以5%为阶梯
# 4.循环判断买入条件
#   1 MACD>0
#   2 b 股价在30日均线1%以内 
#   3 股价在当前档位没有持仓
# 5. 卖出条件
#   1 股价超过持仓最低档卖出价

buylogs = []
selllogs = []
plandf = pd.DataFrame()
tradecenter = trade()

def makeplan(price):
    # 创建购买计划
    logging.info("创建购买计划:%s",price)
    input = pd.Series(np.logspace(-10, 0, 10, base=1.05)*price)
    tem =  (pd.Series(np.arange(24, 5, -2))*0.01)
    out = (tem +1)*input
    global plandf
    plandf = pd.DataFrame({ "input": input, "out": out, "store":0, "tem":tem})
    logging.info("购买计划创建完毕\n%s",plandf)
    logging.info("===")

def getbuyprice():
    # 获取购买价格
    return plandf[plandf.store == 0].input.max()



def judgeBuy(data):
    # 判断买入条件是否满足
    logging.info("判断买入条件")
    log = {}
    try:
        if data.MACD<0 or np.isnan(data.MACD):
            raise Exception("MACD<0 macd:%s", data.MACD)
    except Exception as e:
        buylogs.append({"buymsg":str(e),"buy":False,"date":data.name})
    else:
        
        if  plandf.empty: 
            makeplan(data.ma30)
        #查询如果没有持有则重新设置买卖方案
        sellprice = sellprice = plandf[plandf.store > 0].out.min()   
        if sellprice is np.nan:
            makeplan(data.ma30)
        try:
            buyprice = getbuyprice()
            if data.high<buyprice:
                raise Exception("data.high<buyprice buyprice:%s high:%s", buyprice,data.high)
            if data.low>buyprice:
                raise Exception("data.low>buyprice buyprice:%s low:%s",buyprice, data.low)
            tradecenter.buy(float(buyprice), 100)
            index= plandf[plandf.input == buyprice].index
            plandf.loc[index,'store'] = 100

        except Exception as e:
            buylogs.append({"buymsg":str(e),"buy":False, "date":data.name})
        else:
            buylogs.append({"buymsg":str(data),"buy":buyprice,"date":data.name})

def judgeSell(data):
    # 判断买入条件是否满足
    logging.info("判断买出条件%s",data.high)
    log = {}
 
    try:
        sellprice = plandf[plandf.store > 0].out.min()
        index= plandf[plandf.out == sellprice].index.values[0]
        sellpd = plandf.loc[index]

        if data.high<sellpd.out:
            raise Exception("data.low<sellprice sellprice:{} low:{}",sellpd.out, data.high)
        tradecenter.sell(sellpd.out, sellpd.store)

    except Exception as e:
        selllogs.append({"sellmsg":str(e),"sell":False, "date":data.name})
    else:
        huli = (sellpd.out-sellpd.input)*sellpd.store
        msg = "以{} 卖出成本：{} 获利{}".format(sellpd.out, sellpd.input ,huli)
        selllogs.append({"sellmsg":msg,"sell":sellpd.out,"date":data.name})



if __name__ == '__main__':

    logging.info("根据macd值买入优化v1.0.0 2020.7.14")
    logging.info("args:%s",sys.argv)
    amount = '10000'
    start = '2019-10-01'
    end = '2020-12-01'
    tcode = '000100'

    if len(sys.argv)>1:
        tcode = sys.argv[1]
    if len(sys.argv)>2:
        amount = sys.argv[2]
    if len(sys.argv)>3:
        start = sys.argv[3]
    if len(sys.argv)>4:
        end = sys.argv[4]
    logging.info("begin tcode:%s amount:%s start:%s end:%s",tcode,amount,start,end)
    tradecenter.balance = float(amount)
    share = share(tcode)
    data = share.appendmacd(share.cdata)
    data = share.appendma(data,30)


    data_fecha = data.set_index('date')
    selectData =  data_fecha.loc[start: end]

    balance = []
    for i in range(len(selectData)):
        temdata = selectData.iloc[i]
        judgeBuy(temdata)
        judgeSell(temdata)
        balance.append({"balance":tradecenter.balance,"store":tradecenter.store, "all":tradecenter.balance+tradecenter.store*temdata.close,"date":temdata.name})

    logspd = pd.DataFrame(buylogs)
    logspd.set_index(["date"], inplace=True)

    selllogspd = pd.DataFrame(selllogs)
    selllogspd.set_index(["date"], inplace=True)

    balancepd = pd.DataFrame(balance)
    balancepd.set_index(["date"], inplace=True)
 
    frames = [selectData,logspd,selllogspd,balancepd]
    tem = pd.concat(frames ,axis=1) 
    tem["date"] = tem.index
    path = '~/share/tem/tem.csv'
    tem.to_csv(path)
    logging.info("tem：\n%s",tem)
    print(tem.to_json(orient='records'))
 


    