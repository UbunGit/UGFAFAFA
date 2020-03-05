from trade import trade
import numpy
import sys
import logging
import os

##
# 根据5日均线买卖策略
# 当日收盘价如果在5日均线上方%1位置买入
# 当日收盘价如果在5日均线下方%1位置买出
##

# logpath = './log/'+os.path.split(__file__)[-1].split(".")[0]+'.log'
logpath = './log/tacticsm5.log'
if os.path.isfile(logpath):
    os.remove(logpath)
logging.basicConfig(format='%(asctime)s %(message)s ',filename= logpath )
logging.getLogger().setLevel(logging.DEBUG)

logging.debug("trade"+sys.version)

## 如果收盘价低于开盘价 买入
def fitter(data):
    # data.index.name = 'timestamp'

    btypes = [] #交易类型 -1卖出 0 没操作 1 买入
    scress = []
    counts = []
    stores = []
    amounts = []
    sumAmounts = []
    open_prices = numpy.array(data['open'])
    close_prices = numpy.array(data['close'])
    ma5s = numpy.array(data['ma5'])
    times = numpy.array(data.index)

    for i in range(len(df)):
        isscre = False
        count = 0
        # 收盘价低于五日线 
        close_p = close_prices[i]
        open_p = open_prices[i]
        ma5_p = ma5s[i]
        sellof = (close_prices[i]/ma5s[i])-1
        buylog = (close_prices[i]/ma5s[i])-1
        if (sellof)<-0.005: 
            btypes.append(-1)
            isscre, msg ,count= cent.sell(close_prices[i], times[i], cent.store)
            logging.debug("trade "+'sell '+str(times[i])+" " +str(close_prices[i])+" " +msg)
   
        elif (buylog)>0.005:
            btypes.append(1)
            isscre, msg, count = cent.buy(close_prices[i], times[i], count=2000)
            logging.debug("trade: "+' buy '+str(times[i]) +" "+str(close_prices[i])+" " +msg)
        
        else:
            logging.debug("trade "+str(times[i]) +'无交易')
            btypes.append(0)
        scress.append(isscre)
        counts.append(count)
        amounts.append(cent.balance)
        stores.append(cent.store)
        sumAmount = float(cent.balance) + float(cent.store)*float(close_prices[i])
        sumAmounts.append(sumAmount)
        logging.debug(str(tcode)+"资产"+str(sumAmount)+"持仓"+str(cent.store))
    return btypes,scress,counts,amounts,stores,sumAmounts

amount = 10000
start = '2019-10-18'
end = ''
tcode = '515050'

if len(sys.argv)>1:
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
df['date'] = numpy.array(df.index)
print(df.to_json(orient='records'))