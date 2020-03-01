import tushare as ts
import logging
import talib as tl
import numpy

amount = 10000 # 余额
store = 0 # 持仓
buy_def = 1 # 固定买入手
buy_fee = 100  # 买入手续费
sell_fee = 0.03 #卖出手续费率


        
        



def talib_KDJ(data, fastk_period=9, slowk_period=3, slowd_period=3):
    indicators={}
    #计算kd指标
    high_prices = numpy.array([v['high'] for v in data])
    low_prices = numpy.array([v['low'] for v in data])
    close_prices = numpy.array([v['close'] for v in data])
    indicators['k'], indicators['d'] = tl.STOCH(high_prices, low_prices, close_prices, 
                                                   fastk_period=fastk_period, 
                                                   slowk_period=slowk_period, 
                                                   slowd_period=slowd_period)
    indicators['j'] = 3 * indicators['k'] - 2 * indicators['d']
    return indicators


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
    sumAmount = tstore*price + amount
    return isScress,buycount,tamount,tstore,sumAmount

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
    sumAmount = tstore*price + amount
    return isScress,buycount,tamount,tstore,sumAmount

## 如果收盘价低于开盘价 买入
def fitter(data):
    btypes = [] #交易类型 -1卖出 0 没操作 1 买入
    scress = []
    counts = []
    amounts = []
    stores = []
    sumAmounts = []
    open_prices = numpy.array(data['open'])
    close_prices = numpy.array(data['close'])
    for i in range(len(df)):
        isScress = False
        count = 0
        tamount = amount
        tstore = store
        # 开盘价高于收盘价0.2 卖出
        if (open_prices[i]-close_prices[i])>0.1: 
            btypes.append(-1)
            isScress ,count,tamount,tstore,sumAmount = sell(close_prices[i])
            
        elif (close_prices[i]-open_prices[i])>0.1:
            btypes.append(1)
            isScress ,count,tamount,tstore,sumAmount = buy(close_prices[i])
        else:
            btypes.append(0)
        scress.append(isScress)
        counts.append(count)
        amounts.append(tamount)
        stores.append(tstore)
        sumAmounts.append(sumAmount)
    return btypes,scress,counts,amounts,stores,sumAmounts

def loadData():
    df =  ts.get_k_data(code='000652') #一次性获取全部日k线数据
    df['buy'],df['scress'],df['counts'],df['amounts'], df['store'] ,df['sumAmount']= fitter(df)
    file = '../../file/000652.csv'
    df.to_csv(file)
    print(df.to_json(orient='records'))

