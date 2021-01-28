#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import tushare as ts
import numpy
import pandas
import os,time,logging,json,datetime
import talib as tl
logging.basicConfig(level=logging.NOTSET)  # 设置日志级别
ts.set_token("8631d6ca5dccdcd4b9e0eed7286611e40507c7eba04649c0eee71195")
formattime = (time.strftime('%Y-%m-%d',time.localtime(time.time())))

dpath = '/Users/admin/share/data/'

###
## 单个股票
###
class share:

    cdata = None # 股票数据
    code = None # 股票代码

    def __init__(self, code, begin= None, end= None):
        #根据股票编码初始化数据
        logging.info("share 根据股票编码初始化数据 code:%s 开始：%s 结束：%s",code,begin,end)
        self.code = code
        tsda = self.load()
        if(tsda is None ):
            logging.error("share 初始化失败，为获取到数据")
            return
        tsda = tsda.sort_values(by='date')
        self.cdata = tsda
        if begin is not None:
            self.cdata = self.cdata[self.cdata['date'] >= begin]
        if end is not None:
            self.cdata = self.cdata[self.cdata['date']<= end]
        logging.debug("share 初始化结束")


    def appendmacd(self,data):
        logging.info("MACD BEGIN")
        if(data == None):
            return data
        closes = numpy.array(data['close'])
        diff, dea, macd= tl.MACD(closes,
                            fastperiod=12, slowperiod=26, signalperiod=9 )

        data['MACD']= macd*2
        data['DEA'] = dea
        data['DIFF'] = diff
        logging.info("MACD END")
        return data

    def appendma(self,data, ma):
    
        logging.info("ma %s BEGIN",ma)
        closes = numpy.array(data['close'])
        madata = tl.MA(closes,timeperiod=ma)
        key = "ma"+str(ma)
        data[key]= madata
        logging.info("ma %s END",ma)
        return data

   #计算kd指标
    def appendkdj(self, data, fastk_period=9, slowk_period=3, slowd_period=3):
        logging.info("KDJ BEGIN")
    
        indicators={}
    
        closes = numpy.array(data['close'])
        highs = numpy.array(data['high'])
        lows = numpy.array(data['low'])
        k, d = tl.STOCH(highs, lows, closes, fastk_period=9, slowk_period=3, slowd_period=3)
        data['k']= k
        data['d'] = d
        data['j'] = 3 * k - 2 * d
        logging.info("KDJ END")
        return data

    def appendreal(self, data):
   
        try:
            macd_r = tl.LINEARREG_ANGLE(data['MACD'], timeperiod=3)
            data['MACD_R']= macd_r

            diff_r = tl.LINEARREG_ANGLE(data['DIFF'], timeperiod=3)
            data['DIFF_R']= diff_r

            k_r = tl.LINEARREG_ANGLE(data['k'], timeperiod=3)
            data['K_R']= k_r

            ma5_r = tl.LINEARREG_ANGLE(data['ma5'], timeperiod=3)
            data['MA5_R']= ma5_r

            ma10_r = tl.LINEARREG_ANGLE(data['ma10'], timeperiod=3)
            data['MA10_R']= ma10_r

            ma20_r = tl.LINEARREG_ANGLE(data['ma20'], timeperiod=3)
            data['MA20_R']= ma20_r

        except Exception as e:
            logging.warning("real error%s",e)
        finally:
            logging.warning("real end")
            return data



    def save(self,data):
        path = '~/share/data/'+str(self.code)+'.csv'
        logging.info("保存原始数据:"+path)
        data.to_csv(path)

    def load(self):
        try:
            path = dpath+str(self.code)+'.csv'
            endtime = ""
            if os.path.exists(path):
                etimme = time.localtime(os.path.getmtime(path))
                endtime = time.strftime('%Y-%m-%d',etimme)
            dtimme = time.localtime(time.time())
            todytime = (time.strftime('%Y-%m-%d',dtimme))
            if dtimme.tm_hour<16:
                temtime = datetime.datetime.now()+datetime.timedelta(days=-1)
                todytime = temtime.strftime('%Y-%m-%d')

            if endtime == todytime :
                logging.info("获取缓存数据:"+path)
                temdata = pandas.read_csv(path ,dtype={"date":"string"}, index_col=0,)
                return temdata
            else:
                return self.download()
        except Exception as e:
            logging.info("获取数据失败：paht=")
            logging.warning(e)
            time.sleep(0.1)
            return None
    def download(self):

        tsda = ts.pro_bar(ts_code=self.code, adj='qfq')
        
        if(tsda is None):
            return None
        print(tsda.head())
        tsda = tsda.rename(columns={'trade_date':'date'})
        tsda.sort_index(inplace=True)
        self.save(tsda)
        return tsda
       

###
## 股票列表
###
filepath = dpath+'basics.csv'
class shares:
    basics = None # 股票列表
    def __init__(self,date=formattime):
        temdata = None
        if os.path.exists(filepath):
            logging.info("股票列表--cvs")
            temdata = pandas.read_csv(filepath)
        if temdata is None:
            logging.info("股票列表--tushare")
            temdata = ts.top_list(date)
            temdata.to_csv(filepath)
        self.basics = temdata

    ## 根据条件获取对应的股票列表  
    def fitter(self,key,value):
        logging.info("根据条件获取对应的股票列表")
        return self.basics[self.basics[key]==value]


    def run(self):
        codes = numpy.array(self.basics.index)
        # for i in range(len(codes)):
        for i in range(2):
            temshare = share(code=codes[i])
            temshare.save()

        

if __name__ == '__main__':
    # SH沪股通SZ
    cshare = share('300022.SZ')
    logging.info("result：\n%s",cshare.cdata)
    # result =cshare.appendma(cshare.cdata,30)
    # logging.info("ma result：\n%s",result)
    # # print(cshare.cdata.to_json(orient='records'))

    # shares = shares()
    
 
