from trade import trade
import numpy
import sys
import logging
import os

##
# 根据macd买卖策略
# diff>0 and dea>0 and macd>0买入
# diff<dea or macd<0买出
##
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

    macds = numpy.array(data['MACD'])
    diffs = numpy.array(data['DIFF'])
    deas = numpy.array(data['DEA'])
    closes = numpy.array(data['close'])
    times = numpy.array(data.index)
    masdrs = numpy.array(data['MACD_R'])
    ks = numpy.array(data['k'])
    krs = numpy.array(data['K_R'])
    ma20rs = numpy.array(data['MA20_R'])

    for i in range(len(df)):
        isscre = False
        count = 0
        # 收盘价macd
        macd = macds[i]
        diff = diffs[i]
        dea = deas[i]
        if diff<dea or macd<0 or ks[i]>92 or ma20rs[i]<0 or masdrs[i]<0: 
            btypes.append(-1)
            isscre, msg ,count= cent.sell(closes[i], times[i], cent.store)
            logging.debug("trade "+'sell '+str(times[i])+" " +str(closes[i])+" " +msg)
   
        elif  diff>dea and masdrs[i]>0 and krs[i]>0 and ma20rs[i]>0 and masdrs[i]>0:
            btypes.append(1)
            isscre, msg, count = cent.buy(closes[i], times[i], count=cent.balance/closes[i])
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
start = '2019-10-01'
end = '2020-12-01'
tcode = '300022'

if len(sys.argv)>1:
    tcode = sys.argv[1]
if len(sys.argv)>2:
    amount = sys.argv[2]
if len(sys.argv)>3:
    start = sys.argv[3]
if len(sys.argv)>4:
    end = sys.argv[4]
logging.debug("===================================")
logging.debug(("时间：",start,"~",end))
cent = trade(tcode, begin=start, end=end, balance=amount)
df = cent.cdata
df['buy'],df['scress'],df['counts'],df['amounts'], df['store'] ,df['sumAmount']= fitter(df)
print(df)