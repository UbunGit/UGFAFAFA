from trade import trade
import numpy
import sys


## 如果收盘价低于开盘价 买入
def fitter(data):


    btypes = [] #交易类型 -1卖出 0 没操作 1 买入
    scress = []
    counts = []
    stores = []
    amounts = []
    sumAmounts = []
    
    open_prices = numpy.array(data['open'])
    close_prices = numpy.array(data['close'])
    times = numpy.array(data['date'])

    for i in range(len(df)):
        isscre = False
        count = 0
        # 开盘价高于收盘价 1%
        if ((close_prices[i]/open_prices[i])-1)<-0.05: 
            btypes.append(-1)
            isscre, msg ,count= cent.sell(close_prices[i], times[i], cent.store)
   
        elif ((close_prices[i]/open_prices[i])-1)>0.05:
            btypes.append(1)
            isscre, msg, count = cent.buy(close_prices[i], times[i], count=100)
        
        else:
            btypes.append(0)
        scress.append(isscre)
        counts.append(count)
        amounts.append(cent.balance)
        stores.append(cent.store)
        sumAmount = float(cent.balance) + float(cent.store)*float(close_prices[i])
        sumAmounts.append(sumAmount)
    return btypes,scress,counts,amounts,stores,sumAmounts

amount = 10000
start = ''
end = ''
tcode = sys.argv[1]

if len(sys.argv)>2:
    amount = sys.argv[2]
if len(sys.argv)>3:
    start = sys.argv[3]
if len(sys.argv)>4:
    end = sys.argv[4]

cent = trade(tcode, begin=start, end=end, balance=amount)
df = cent.data
df['buy'],df['scress'],df['counts'],df['amounts'], df['store'] ,df['sumAmount']= fitter(df)
print(df.to_json(orient='records'))