#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging
import sys,os

from flask import Flask
from flask import request
from flask import Response
from flask import  abort
import json
import zxby
from trade import share
from fitter import macdfitter
from flask_cors import CORS
from flask_apscheduler import APScheduler

logging.basicConfig(level=logging.NOTSET)  # 设置日志级别


app = Flask(__name__)

CORS(app, supports_credentials=True)


def Response_headers(content):
    resp = Response(content)
    resp.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization,session_id')
    resp.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS,HEAD')
    resp.headers['Access-Control-Allow-Origin'] = '*'
    return resp

def decode(s):
    try:
        return s.decode('utf-8')
    except UnicodeDecodeError:
        return s.decode('gbk')



 
 # 根据时间获取股票交易历史数据
@app.route('/sharehistory')
def sharehistory():
    if request.method == 'GET':

        try:
            code = request.args.get("code")
            begin = request.args.get("begin")
            cshare = share(code)
            data = cshare.cdata
            data = cshare.appendmacd(data)
            data = data[data.date>=begin]
            
            jsondata =json.loads(data.to_json(orient='records')) 
            return json.dumps({"code": 200,"data":jsondata})

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
 
@app.route('/tactics')
def tactics():
    return json.dumps(jsondata)
 
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


 
if __name__ == '__main__':

    app.run(debug=True)

