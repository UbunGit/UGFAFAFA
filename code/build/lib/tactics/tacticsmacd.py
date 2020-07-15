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
    times = numpy.array(data.date)
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
        if diff>dea and krs[i]>0 and ma20rs[i]>-5 and masdrs[i]>0:
            btypes.append(1)
            isscre, msg, count = cent.buy(closes[i], times[i], count=cent.balance/closes[i])
            logging.debug("diff:%s dea:%s dea:%s ma20rs:%s masdrs:%s",diff,dea,krs[i],ma20rs[i],masdrs[i])
            logging.debug(str(times[i])+' 买入 ' +str(tcode)+" "+str(closes[i])+" " +msg)
   
        elif  diff<dea or macd<0 or ks[i]>90 or ma20rs[i]<0 or masdrs[i]<0 or krs[0]<0: 
            btypes.append(-1)
            isscre, msg ,count= cent.sell(closes[i], times[i], cent.store)
            logging.debug("diff:%s dea:%s dea:%s ma20rs:%s masdrs:%s macd:%s ks:%s",diff,dea,krs[i],ma20rs[i],masdrs[i],macd,ks[i])
            logging.debug(str(times[i])+'卖出 '+str(tcode)+" " +str(closes[i])+" " +msg)
        
        else:
            logging.debug("trade "+str(times[i]) +'无交易')
            btypes.append(0)
        scress.append(isscre)
        counts.append(count)
        amounts.append(cent.balance)
        stores.append(cent.store)
        sumAmount = float(cent.balance) + float(cent.store)*float(closes[i])
        sumAmounts.append(sumAmount)
        logging.debug("资产"+str(sumAmount)+"持仓"+str(cent.store))
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


cent = trade(tcode, begin=start, end=end, balance=amount)
df = cent.cdata

df['buy'],df['scress'],df['counts'],df['amounts'], df['store'] ,df['sumAmount']= fitter(df)
# logging.debug("===================================")
# logging.debug("tacticsm5 结果:%s",df)
# logging.debug("===================================")
print(df.to_json(orient='records'))