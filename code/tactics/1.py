#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from trade import share
from trade import trade
import numpy
import sys
import logging
import os, json
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
    input = pd.Series(np.logspace(-9, 1, 10, base=1.05)*price)
    tem =  (pd.Series(np.arange(30, 10, -2))*0.01)
    out = (tem +1)*input
    global plandf
    plandf = pd.DataFrame({ "input": input, "out": out, "store":0, "tem":tem})
    logging.info("购买计划创建完毕\n%s",plandf)

def getbuyprice(price):
    tempd = plandf[plandf.store == 0]
    tempd = tempd[tempd.input >= price]
    return tempd.input.min()

def getcount(price,amount):
    minc = int(amount/price)
    maxc = minc+1
    if abs(minc*price-amount)>abs(maxc*price-amount):
        return maxc
    return minc


def judgeBuy(data):
    # 判断买入条件是否满足
    logging.info("判断买入条件")
    log = {}
    try:
        if data.MACD<0 or np.isnan(data.MACD):
            raise Exception("MACD<0 macd:{:.2f}".format(data.MACD))
        if data.MACD>0.2:
            raise Exception("MACD>0.2 macd:{:.2f}".format( data.MACD))
        # if data.DEA>0:
        #     raise Exception("data.DEA dea:{:.2f}".format( data.DEA))
    except Exception as e:
        buylogs.append({"buymsg":str(e),"buy":False,"date":data.name})
    else:
        
        if  plandf.empty: 
            makeplan(data.ma30)
        #如果没有持有则重新设置买卖方案
        if tradecenter.store <=0:
            makeplan(data.ma30)
        try:
            buyprice = getbuyprice(data.low)
            
            if data.high<buyprice:
                raise Exception("data.high<buyprice buyprice:{:.2f} high:{:.2f}".format( buyprice,data.high))
            if data.low>buyprice:
                raise Exception("data.low>buyprice buyprice:{:.2f} low:{:.2f}".format(buyprice, data.low))
            buycount = getcount(buyprice,2000)
            tradecenter.buy(float(buyprice), buycount)
            index= plandf[plandf.input == buyprice].index
            plandf.loc[index,'store'] = buycount

        except Exception as e:
            buylogs.append({"buymsg":str(e),"buy":False, "date":data.name})
        else:
            index= plandf[plandf.input == buyprice].index.values[0]
            tempd = plandf.loc[index]
            msg = "以{:.2f} 卖入 {:.2f} 期望价 {:.2f}".format(buyprice,buycount, tempd.out)
            buylogs.append({"buymsg":msg,"buy":buyprice,"date":data.name})

def judgeSell(data):
    # 判断买出条件是否满足
    logging.info("判断买出条件%s",data.high)
    log = {}
 
    try:
        if tradecenter.store<=0:
            raise Exception("store is zero")
        
        sellprice = plandf[plandf.store > 0].out.min()
        index= plandf[plandf.out == sellprice].index.values[0]
        sellpd = plandf.loc[index]

        if data.high<sellpd.out:
            raise Exception("data.low<sellprice sellprice:{:.2f} low:{:.2f}".format(sellpd.out, data.high))
        # if data.MACD>0.0 or np.isnan(data.MACD):
        #     raise Exception("MACD>0 macd:{:.2f}".format(data.MACD))
        tradecenter.sell(sellpd.out, sellpd.store)

    except Exception as e:
        selllogs.append({"sellmsg":str(e),"sell":False, "date":data.name})
    else:

        plandf.loc[index,'store'] = 0
        huli = (sellpd.out-sellpd.input)*sellpd.store
        msg = "以{:.2f} 卖出成本：{:.2f} 个数：{:.2f} 获利{:.2f}".format(sellpd.out, sellpd.input ,sellpd.store,huli)
        selllogs.append({"sellmsg":msg,"sell":sellpd.out,"date":data.name})



if __name__ == '__main__':

    logging.info("根据macd值买入优化v1.0.0 2020.7.14")
    logging.info("args:%s",sys.argv)
    amount = '10000'
    start = '20200301'
    end = '20200510'
    tcode = '300022.SZ'
    if len(sys.argv)>1 and len(sys.argv[1])>0:
        indata = json.loads(sys.argv[1])
        if "start" in indata:
            start=indata["start"]
        if "end" in indata:
            end=indata["end"]
        if "amount" in indata:
            amount=indata["amount"]
        if "tcode" in indata:
            tcode=indata["tcode"]
        
    logging.info("begin tcode:%s amount:%s start:%s end:%s",tcode,amount,start,end)
    tradecenter.balance = float(amount)
    share = share(tcode)
    data = share.appendmacd(share.cdata)
    data = share.appendma(data,30)



    data_fecha = data[data.date>=start]
    selectData =  data_fecha[data_fecha.date<=end]
    logging.info("selectData:\n%s",selectData)

    balance = []
    plands = []
    firstData = selectData.iloc[0]
    for i in range(len(selectData)):
        temdata = selectData.iloc[i]
        judgeBuy(temdata)
        judgeSell(temdata)
        rate = ((tradecenter.balance+(tradecenter.store*temdata.close))/float(amount))-1
        vrate = (temdata.close/firstData.close)-1
        balance.append({
            "balance":tradecenter.balance,
            "store":tradecenter.store,
            "rate":rate*1.0,
            "vrate":vrate*1.0,
            "all":(tradecenter.balance+tradecenter.store*temdata.close)*1.0,
            "date":temdata.name})
        plands.append({"plandf":plandf.to_json(orient='records'),"date":temdata.name})

    logging.info("selectData:\n%s",selectData)
    logspd = pd.DataFrame(buylogs)
    logspd.set_index(["date"], inplace=True)

    selllogspd = pd.DataFrame(selllogs)
    selllogspd.set_index(["date"], inplace=True)

    balancepd = pd.DataFrame(balance)
    balancepd.set_index(["date"], inplace=True)

    plandspd = pd.DataFrame(plands)
    plandspd.set_index(["date"], inplace=True)
 
    frames = [selectData,logspd,selllogspd,balancepd,plandspd]
    tem = pd.concat(frames ,axis=1) 
    
    logging.info("tem:\n%s",tem)
    path = '~/share/tem/tem.csv'
    tem.to_csv(path)
 


    