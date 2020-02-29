import tushare as ts
import logging
import talib as tl
import numpy

amount = 10000 # 余额
store = 0 # 持仓
buy_def = 1 # 固定买入手
buy_fee = 100  # 买入手续费
sell_fee = 0.03 #卖出手续费率

# buy
def buy(price,buycount=buy_def*100):

    isScress = False
    global amount
    global store
    tamount = amount
    tstore = store
    # step 计算所需金额
    a_price = price*buycount
    # step 计算余额是否充足
    if a_price<amount :
        tamount = tamount-a_price-buy_fee
        tstore = tstore+buycount
        isScress = True
    amount = tamount
    store = tstore
    return isScress,buycount,tamount,tstore

# sell
def sell(price,buycount=0):
    isScress = False
    
    global amount
    global store
    tamount = amount
    tstore = store
    buycount = tstore
    # step 计算所需金额
    a_price = price*tstore
    # step 计算余额是否充足
    if a_price>0 :
        tamount = tamount+ a_price- sell_fee*a_price
        tstore = 0
        isScress = True
    amount = tamount
    store = tstore
    return isScress,buycount,tamount,tstore

## 如果收盘价低于开盘价 买入
def fitter(data):
    btypes = [] #交易类型 -1卖出 0 没操作 1 买入
    scress = []
    counts = []
    amounts = []
    stores = []
    open_prices = numpy.array(data['open'])
    close_prices = numpy.array(data['close'])
    for i in range(len(data)):
        isScress = False
        count = 0
        tamount = amount
        tstore = store
        # 开盘价高于收盘价0.2 卖出
        if (open_prices[i]-close_prices[i])>0.5: 
            btypes.append(-1)
            isScress ,count,tamount,tstore = sell(close_prices[i])
            
        elif (close_prices[i]-open_prices[i])>0.5:
            btypes.append(1)
            isScress ,count,tamount,tstore = buy(close_prices[i])
        else:
            btypes.append(0)
        scress.append(isScress)
        counts.append(count)
        amounts.append(tamount)
        stores.append(tstore)

    return btypes,scress,counts,amounts,stores
    
# 获取股票历史数据
def loadData():
    return ts.get_k_data(code='000652')

def start():
    df = loadData()
    df['buy'],df['scress'],df['counts'],df['amounts'], df['store'] = fitter(df)
    return df.to_dict(orient='records')
    # return df.to_json(orient='records')