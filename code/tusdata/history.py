import tushare as ts
import logging
import talib as tl
import numpy



def talib_KDJ(data, fastk_period=9, slowk_period=3, slowd_period=3):
    indicators={}
    #计算kd指标
    high_prices = numpy.array([v['high'] for v in data])
    low_prices = numpy.array([v['low'] for v in data])
    close_prices = numpy.array([v['close'] for v in data])
    indicators['k'], indicators['d'] = talib.STOCH(high_prices, low_prices, close_prices, 
                                                   fastk_period=fastk_period, 
                                                   slowk_period=slowk_period, 
                                                   slowd_period=slowd_period)
    indicators['j'] = 3 * indicators['k'] - 2 * indicators['d']
    return indicators


# step1 获取股票列表

# step2 获取每一个股票的交易数据

# step3 保存到数据库
# engine = create_engine('mysql://user:passwd@127.0.0.1/FAFA?charset=utf8')
df =  ts.get_k_data('000100') #一次性获取全部日k线数据

# df.sort_index(inplace=True)
diff, dea, macd  = tl.MACD(df.close, fastperiod=12, slowperiod=26, signalperiod=9)
macd = macd * 2
df['DIFF'], df['DEA'], df['macd'] = [diff,dea,macd]
print(df)

