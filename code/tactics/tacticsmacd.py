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
logpath = './tacticsm5.log'
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

    macds = numpy.array(data['MACD'])
    diffs = numpy.array(data['DIFF'])
    defs = numpy.array(data['DEA'])
    closes = numpy.array(data['close'])
    times = numpy.array(data.index)

    for i in range(len(df)):
        isscre = False
        count = 0
        # 收盘价macd
        macd = macds[i]
        diff = diffs[i]
   
        if macd<0.01 and diff<0.01: 
            btypes.append(-1)
            isscre, msg ,count= cent.sell(closes[i], times[i], cent.store)
            logging.debug("trade "+'sell '+str(times[i])+" " +str(closes[i])+" " +msg)
   
        elif macd<0.01 or diff<0.01:
            btypes.append(1)
            isscre, msg, count = cent.buy(closes[i], times[i], count=200)
            logging.debug("trade: "+' buy '+str(times[i]) +" "+str(closes[i])+" " +msg)
        
        else:
            logging.debug("trade "+str(times[i]) +'无交易')
            btypes.append(0)
        scress.append(isscre)
        counts.append(count)
        amounts.append(cent.balance)
        stores.append(cent.store)
        sumAmount = float(cent.balance) + float(cent.store)*float(closes[i])
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
df = cent.cdata
df['buy'],df['scress'],df['counts'],df['amounts'], df['store'] ,df['sumAmount']= fitter(df)
df['date'] = numpy.array(df.index)
print(df.to_json(orient='records'))