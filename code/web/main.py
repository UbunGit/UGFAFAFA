#!/usr/bin/env python3
# -*- coding: utf-8 -*-



import logging
import sys,os
import json

sys.path.append("..") 

from flask import Flask
from flask import request
from flask import  abort

from .zxby import *
from .unit import *

from trade import share
from fitter import macdfitter
from flask_cors import CORS
from flask_apscheduler import APScheduler

from database import session

logging.basicConfig(level=logging.NOTSET)  # 设置日志级别

app = Flask(__name__)

CORS(app, supports_credentials=True)

def decode(s):
    try:
        return s.decode('utf-8')
    except UnicodeDecodeError:
        return s.decode('gbk')

@app.teardown_request
def shutdown_session(exception=None):
    session.remove()

 # 根据时间获取股票交易历史数据
@app.route('/sharehistory')
def sharehistory():
    '''
        获取股票历史数据

    Parameters
    --------
        code:股票代码
        begin:开始日期 2020-10-11
    
    Return
    --------
        DataFrame
            date：日期
            open：开盘价
            high：最高价
            close：收盘价
            low：最低价
            volume：成交量
            price_change：价格变动
            p_change：涨跌幅
            ma5：5日均价
            ma10：10日均价
            ma20:20日均价
            v_ma5:5日均量
            v_ma10:10日均量
            v_ma20:20日均量
            turnover:换手率[注：指数无此项]
    '''
    if request.method == 'GET':
        try:
            code = request.args.get("code")
            begin = request.args.get("begin")
            cshare = share(code)
            data = cshare.cdata
            data = cshare.appendmacd(data)
            data = data[data.date>=begin]
            
            jsondata =json.loads(data.to_json(orient='records')) 
            
            return Response_headers(json.dumps({"code": 200,"data":jsondata}))

        except Exception as e:
            logging.error("根据时间获取股票交易历史数据 Exception %s",e)
            return json.dumps({"code": -1,"data":str(e)})
 


 # 获取推荐股票

@app.route('/fitterList')
def chooseList():
    if request.method == 'GET':
        logging.info("获取推荐股票 begin")
        try:
            date = request.args.get("date")
            logging.info("获取推荐股票 date %s",date)
            jsondata =json.loads(macdfitter(date)) 
            return json.dumps({"code": 200,"data":jsondata})
        except Exception as e:
            logging.error("获取推荐股票 Exception %s",e)
            return json.dumps({"code": -1,"data":str(e)})
      
@app.route('/run', methods=['POST'])
def run():
    if request.method == 'POST' and request.form['code']:
        tcode = '000100'
        amount = 10000
        start = None
        end  = None
        parms =  request.form.to_dict()
        if 'tcode' in parms:
            tcode = parms['tcode']
        if 'amount' in parms:
            amount = parms['amount']
        if 'start' in parms:
            start = parms['start']
        if 'end' in parms:
            end = parms['end']
        try:
            code = request.form['code']
            jsondata = zxby.main(code= code,tcode = tcode,amount = amount,start = start,end = end)
            return json.dumps({"code": 200,"data":jsondata})
        except Exception as e:
            return json.dumps({"code": -1,"data":str(e)})
    return Response_headers(str("jsondata"))
 
 
@app.errorhandler(403)
def page_not_found(error):
    content = json.dumps({"code": "403","message":"erroe"})
    resp = Response_headers(content)
    return resp
 
 
@app.errorhandler(404)
def page_not_found(error):
    content = json.dumps({"code": 404})
    resp = Response_headers(content)
    return resp
 
 
@app.errorhandler(400)
def page_not_found(error):
    content = json.dumps({"code": 400})
    resp = Response_headers(content)
    return resp
 
 
@app.errorhandler(405)
def page_not_found(error):
    content = json.dumps({"code": 405})
    resp = Response_headers(content)
    return resp
 
 
@app.errorhandler(410)
def page_not_found(error):
    content = json.dumps({"code": 410})
    resp = Response_headers(content)
    return resp
 
 
@app.errorhandler(500)
def page_not_found(error):
    content = json.dumps({"code": 500})
    resp = Response_headers(content)
    return resp

from .api_share import share
app.register_blueprint(share,url_prefix='/share')

from .api_share_like import sharelike
app.register_blueprint(sharelike,url_prefix='/sharelike')

from .api_tactics import tactics
app.register_blueprint(tactics,url_prefix='/tactics')

from .api_tactics_input import tacticsInput
app.register_blueprint(tacticsInput,url_prefix='/tacticsinput')

def start():
    init_db()
    app.run( debug=True, host="0.0.0.0")

if __name__ == '__main__':
    
    start()
